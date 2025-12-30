// MusicPage.ets
import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { Song, createSong } from './SongModel';
import { FavoriteManager } from './FavoriteManager';

@Entry
@Component
export struct MusicPage {
  // AVPlayer实例
  private avPlayer: media.AVPlayer | null = null;

  // 状态变量
  @State state: string = 'idle';
  @State duration: number = 0;
  @State angleNum: number = 0;
  @State currentProgress: number = 0;
  @State currentSongIndex: number = 0;
  @State playMode: 'sequential' | 'random' | 'loop' = 'sequential';
  @State isPlayerReady: boolean = false;
  // 添加标志位确保 context 已设置
  private isContextSet: boolean = false;
  // 每首歌的收藏状态
  @State songFavoriteStatus: boolean[] = [];
  @State isLoading: boolean = false;

  // 收藏管理器
  private favoriteManager: FavoriteManager = FavoriteManager.getInstance();

  // 歌曲列表 - 使用 createSong 函数创建
  private songList: Song[] = [
    createSong(1, '七里香', '周杰伦', '七里香-周杰伦.mp3', 'app.media.Music_cover'),
    createSong(2, '晴天', '周杰伦', '晴天-周杰伦.mp3', 'app.media.Music_cover'),
    createSong(3, '稻香', '周杰伦', '稻香-周杰伦.mp3', 'app.media.Music_cover'),
    createSong(4, '花海', '周杰伦', '花海-周杰伦.mp3', 'app.media.Music_cover'),
    createSong(5, '青花瓷', '周杰伦', '青花瓷.mp3', 'app.media.Music_cover')
  ];

  aboutToAppear() {
    // 获取context并设置到收藏管理器
    let context = getContext(this) as common.UIAbilityContext;
    this.favoriteManager.setContext(context);

    // 初始化收藏状态
    this.initializeFavoriteStatus();
    this.createAVPlayer();
  }

  aboutToDisappear() {
    this.releaseAVPlayer();
  }

  // 初始化收藏状态
  async initializeFavoriteStatus() {
    this.isLoading = true;

    // 给一些时间让收藏管理器加载数据，因为初始化是异步的，我们等待更长的时间
    await new Promise<void>(resolve => setTimeout(resolve, 200));

    this.songFavoriteStatus = this.songList.map(song =>
    this.favoriteManager.isFavorite(song.id)
    );

    this.isLoading = false;
    console.info('收藏状态初始化完成:', this.songFavoriteStatus);
  }

  // 获取当前歌曲的收藏状态
  getCurrentSongFavorited(): boolean {
    if (this.currentSongIndex >= 0 && this.currentSongIndex < this.songList.length) {
      return this.songFavoriteStatus[this.currentSongIndex];
    }
    return false;
  }

  // 切换当前歌曲的收藏状态
  async toggleFavorite() {
    if (this.isLoading) {
      console.warn('正在加载中，请稍后');
      return;
    }

    const song = this.songList[this.currentSongIndex];
    const currentStatus = this.songFavoriteStatus[this.currentSongIndex];

    try {
      if (currentStatus) {
        // 取消收藏
        await this.favoriteManager.removeFavorite(song.id);
        this.songFavoriteStatus[this.currentSongIndex] = false;
        console.info(`已取消收藏: ${song.title}`);
      } else {
        // 添加收藏
        await this.favoriteManager.addFavorite(song);
        this.songFavoriteStatus[this.currentSongIndex] = true;
        console.info(`已收藏: ${song.title}`);
      }

      // 触发UI更新
      this.songFavoriteStatus = [...this.songFavoriteStatus];

      // 显示收藏数量变化
      console.info(`当前收藏总数: ${this.favoriteManager.getFavoriteCount()}`);
    } catch (error) {
      console.error('收藏操作失败:', error);
    }
  }

  // 跳转到收藏页面
  navigateToFavorites() {
    console.info('正在跳转到收藏页面');
    router.pushUrl({
      url: 'pages/music/FavoritesPage'
    }).then(() => {
      console.info('跳转成功');
    }).catch((error: Error) => {
      console.error('跳转失败:', error);
    });
  }

  // 创建AVPlayer实例
  async createAVPlayer() {
    try {
      this.avPlayer = await media.createAVPlayer();
      if (this.avPlayer) {
        console.info('AVPlayer创建成功');
        this.setAVPlayerCallback();
        await this.loadCurrentSong();
        this.isPlayerReady = true;
      } else {
        console.error('AVPlayer创建失败');
      }
    } catch (error) {
      console.error(`创建AVPlayer失败: ${error.message}`);
    }
  }

  // 释放AVPlayer资源
  releaseAVPlayer() {
    if (this.avPlayer) {
      this.avPlayer.release();
      this.avPlayer = null;
      this.isPlayerReady = false;
      console.info('AVPlayer资源已释放');
    }
  }

  // 注册AVPlayer回调函数
  setAVPlayerCallback() {
    if (!this.avPlayer) return;

    // 状态变化回调
    this.avPlayer.on('stateChange', async (state: string) => {
      console.info(`播放器状态变化: ${state}`);
      this.state = state;

      switch (state) {
        case 'idle':
          break;
        case 'initialized':
          try {
            await this.avPlayer!.prepare();
          } catch (error) {
            console.error(`准备失败: ${error.message}`);
          }
          break;
        case 'prepared':
          this.duration = this.avPlayer!.duration;
          this.songList[this.currentSongIndex].duration = this.duration;
          console.info(`歌曲时长: ${this.duration}ms`);
          break;
        case 'playing':
          this.angleNum = 360;
          console.info('正在播放');
          break;
        case 'paused':
          console.info('已暂停');
          break;
        case 'completed':
          this.currentProgress = 0;
          this.angleNum = 0;
          console.info('播放完成');
          this.onNext();
          break;
        case 'stopped':
          this.currentProgress = 0;
          this.angleNum = 0;
          console.info('已停止');
          break;
        case 'error':
          console.error('播放器遇到错误');
          break;
      }
    });

    // 播放进度回调
    this.avPlayer.on('timeUpdate', (time: number) => {
      if (this.avPlayer && this.state === 'playing') {
        this.currentProgress = time;
      }
    });

    // 播放错误回调
    this.avPlayer.on('error', (error: BusinessError) => {
      console.error(`播放器错误: ${error.message}, 错误码: ${error.code}`);
    });
  }

  // 加载当前歌曲
  async loadCurrentSong() {
    if (!this.avPlayer) {
      console.error('AVPlayer未初始化');
      return;
    }

    try {
      // 停止当前播放（如果有）
      if (this.state === 'playing' || this.state === 'paused') {
        await this.avPlayer.stop();
      }

      // 重置播放器状态
      await this.avPlayer.reset();

      // 获取当前歌曲的文件名
      const fileName = this.songList[this.currentSongIndex].fileName;
      console.info(`正在加载歌曲: ${fileName}`);

      // 获取资源文件的FD路径
      let context = getContext(this) as common.UIAbilityContext;
      let fileDir = await context.resourceManager.getRawFd(fileName);

      if (fileDir && fileDir.fd > 0) {
        console.info(`文件加载成功, fd: ${fileDir.fd}`);
        this.avPlayer.fdSrc = fileDir;
      } else {
        console.error(`加载文件失败: ${fileName}`);
      }
    } catch (error) {
      console.error(`加载歌曲错误: ${error.message}`);
    }
  }

  // 播放/暂停
  async togglePlayPause() {
    if (!this.avPlayer) {
      console.error('AVPlayer未初始化');
      return;
    }

    try {
      if (this.state === 'playing') {
        await this.avPlayer.pause();
        this.state = 'paused';
        this.angleNum = 0;
        console.info('已暂停播放');
      } else if (this.state === 'paused' || this.state === 'completed') {
        await this.avPlayer.play();
        this.state = 'playing';
        this.angleNum = 360;
        console.info('开始播放');
      } else if (this.state === 'prepared' || this.state === 'initialized') {
        await this.avPlayer.play();
        this.state = 'playing';
        this.angleNum = 360;
        console.info('开始播放');
      } else {
        // 如果播放器未就绪，重新加载当前歌曲
        await this.loadCurrentSong();
        await this.avPlayer.play();
        this.state = 'playing';
        this.angleNum = 360;
        console.info('重新加载并开始播放');
      }
    } catch (error) {
      console.error(`播放/暂停操作错误: ${error.message}`);
    }
  }

  // 播放指定索引的歌曲
  async playSongAtIndex(index: number) {
    if (index < 0 || index >= this.songList.length) {
      console.error('无效的歌曲索引');
      return;
    }

    // 更新当前歌曲索引
    this.currentSongIndex = index;

    // 重置进度
    this.currentProgress = 0;
    this.angleNum = 0;

    // 加载并播放新歌曲
    await this.loadCurrentSong();

    // 自动播放
    if (this.avPlayer && (this.state === 'playing' || this.state === 'paused')) {
      await this.avPlayer.play();
      this.state = 'playing';
      this.angleNum = 360;
    }

    console.info(`切换到第 ${index + 1} 首: ${this.songList[index].title}`);
  }

  // 上一曲
  async onPrev() {
    let newIndex: number;

    switch (this.playMode) {
      case 'random':
        newIndex = Math.floor(Math.random() * this.songList.length);
        console.info(`随机播放模式，选择第 ${newIndex + 1} 首`);
        break;
      case 'loop':
        newIndex = this.currentSongIndex;
        console.info('单曲循环模式，播放当前歌曲');
        break;
      case 'sequential':
      default:
        newIndex = this.currentSongIndex - 1;
        if (newIndex < 0) {
          newIndex = this.songList.length - 1;
        }
        console.info(`顺序播放模式，播放上一首`);
        break;
    }

    await this.playSongAtIndex(newIndex);
  }

  // 下一曲
  async onNext() {
    let newIndex: number;

    switch (this.playMode) {
      case 'random':
        newIndex = Math.floor(Math.random() * this.songList.length);
        console.info(`随机播放模式，选择第 ${newIndex + 1} 首`);
        break;
      case 'loop':
        newIndex = this.currentSongIndex;
        console.info('单曲循环模式，播放当前歌曲');
        break;
      case 'sequential':
      default:
        newIndex = this.currentSongIndex + 1;
        if (newIndex >= this.songList.length) {
          newIndex = 0;
        }
        console.info(`顺序播放模式，播放下一首`);
        break;
    }

    await this.playSongAtIndex(newIndex);
  }

  // 切换播放模式
  togglePlayMode() {
    const modes: ('sequential' | 'random' | 'loop')[] = ['sequential', 'random', 'loop'];
    const currentIndex = modes.indexOf(this.playMode);
    this.playMode = modes[(currentIndex + 1) % modes.length];

    console.info(`切换播放模式为: ${this.getPlayModeText()}`);
  }

  // 获取播放模式显示文本
  getPlayModeText(): string {
    switch (this.playMode) {
      case 'sequential':
        return '顺序播放';
      case 'random':
        return '随机播放';
      case 'loop':
        return '单曲循环';
      default:
        return '顺序播放';
    }
  }

  // 格式化时间显示（毫秒转分:秒）
  formatTime(milliseconds: number): string {
    if (!milliseconds) return '00:00';
    const totalSeconds = Math.floor(milliseconds / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Button() {
          Image($r('app.media.Music_back'))
            .width('60%')
            .height('60%')
        }
        .width(40)
        .height(30)
        .backgroundColor('#F0F8FF')
        .borderRadius(15)
        .onClick(() => {
          router.back();
        });

        Blank();
        Text('音乐').fontSize(20).fontWeight(FontWeight.Bold).fontColor('#222222');
        Blank();

        // 收藏页面入口按钮
        Button() {
          Image($r('app.media.Music_search'))
            .width('60%')
            .height('60%')
        }
        .width(40)
        .height(30)
        .backgroundColor('#F0F8FF')
        .borderRadius(15)
        .onClick(() => {
          this.navigateToFavorites();
        });
      }
      .width('100%')
      .padding({ left: 15, right: 15, top: 20 });

      // 专辑封面（带旋转动画）
      Stack() {
        Image($r(this.songList[this.currentSongIndex].cover))
          .width('100%')
          .height('100%')
          .borderRadius(100)
      }
      .width(200)
      .height(200)
      .borderRadius(100)
      .margin({ top: 30 })
      .rotate({ angle: this.angleNum })
      .animation({
        duration: 10000, // 固定旋转速度
        curve: Curve.Linear,
        iterations: -1,
        playMode: PlayMode.Normal
      });

      // 歌词区域
      Stack() {
        Text('歌词')
          .fontSize(18)
          .fontColor('#666666');
      }
      .width('90%')
      .height(200)
      .backgroundColor('#FAFAFA')
      .border({ width: 1, color: '#E5E5E5' })
      .margin({ top: 20 });

      // 歌曲信息
      Column() {
        Text(this.songList[this.currentSongIndex].title)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A');

        Text(this.songList[this.currentSongIndex].artist)
          .fontSize(16)
          .fontColor('#666666')
          .margin({ top: 5 });

        // 显示收藏状态信息
        Row() {
          Text(`${this.currentSongIndex + 1}/${this.songList.length}`)
            .fontSize(14)
            .fontColor('#888888');

          Text(` | 已收藏 ${this.favoriteManager.getFavoriteCount()} 首`)
            .fontSize(14)
            .fontColor('#FF6B6B')
            .margin({ left: 10 });
        }
        .margin({ top: 3 });
      }
      .alignItems(HorizontalAlign.Center)
      .margin({ top: 10 });

      // 播放控制区域
      Column() {
        // 时间显示和进度条
        Row() {
          Text(this.formatTime(this.currentProgress))
            .fontSize(12)
            .fontColor('#666666')
            .width('15%')
            .textAlign(TextAlign.Start);

          Slider({
            value: this.currentProgress,
            min: 0,
            max: this.duration || 1,
            style: SliderStyle.OutSet
          })
            .width('70%')
            .onChange((value: number) => {
              if (this.avPlayer && (this.state === 'playing' || this.state === 'paused')) {
                this.avPlayer.seek(value);
                this.currentProgress = value;
              }
            });

          Text(this.formatTime(this.duration))
            .fontSize(12)
            .fontColor('#666666')
            .width('15%')
            .textAlign(TextAlign.End);
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 20, right: 20 });

        // 播放控制按钮栏
        Row() {
          // 收藏按钮
          Button() {
            Image(this.getCurrentSongFavorited()
              ? $r('app.media.Music_active_best')  // 已收藏图标
              : $r('app.media.Music_normal')       // 未收藏图标
            )
              .width('100%')
              .height('100%')
          }
          .width(40)
          .height(40)
          .backgroundColor('transparent')
          .onClick(() => {
            this.toggleFavorite();
          });

          // 上一曲按钮
          Button() {
            Image($r('app.media.Music_prev'))
              .width('100%')
              .height('100%')
          }
          .width(40)
          .height(40)
          .backgroundColor('transparent')
          .margin({ left: 30 })
          .onClick(() => {
            this.onPrev();
          });

          // 播放/暂停按钮
          Button() {
            Image(this.state === 'playing'
              ? $r('app.media.Music_play1')
              : $r('app.media.Music_pause')
            )
              .width('100%')
              .height('100%')
          }
          .width(50)
          .height(50)
          .backgroundColor('transparent')
          .margin({ left: 30 })
          .onClick(() => {
            this.togglePlayPause();
          });

          // 下一曲按钮
          Button() {
            Image($r('app.media.Music_next'))
              .width('100%')
              .height('100%')
          }
          .width(40)
          .height(40)
          .backgroundColor('transparent')
          .margin({ left: 30 })
          .onClick(() => {
            this.onNext();
          });

          // 播放模式按钮
          Button() {
            Text(this.getPlayModeText())
              .fontSize(12)
              .fontColor('#666666')
          }
          .width(80)
          .height(30)
          .backgroundColor('#F5F5F5')
          .borderRadius(15)
          .margin({ left: 30 })
          .onClick(() => {
            this.togglePlayMode();
          });
        }
        .margin({ top: 20 })
        .width('100%')
        .justifyContent(FlexAlign.Center);

        // 查看收藏按钮
        Button('查看收藏列表', { type: ButtonType.Normal })
          .width('60%')
          .height(40)
          .backgroundColor('#4A90E2')
          .fontColor('#FFFFFF')
          .borderRadius(20)
          .margin({ top: 30 })
          .onClick(() => {
            this.navigateToFavorites();
          });

        // 调试信息区域
        Column() {
          // 显示当前收藏状态
          Row() {
            Text(this.isContextSet ? '✓ Context 已设置' : '✗ Context 未设置')
              .fontSize(12)
              .fontColor(this.isContextSet ? '#00AA00' : '#FF0000')
          }
          .margin({ top: 5 });

          // 调试按钮（开发时使用）
          Button('调试信息', { type: ButtonType.Normal })
            .width('40%')
            .height(30)
            .backgroundColor('#888888')
            .fontColor('#FFFFFF')
            .borderRadius(15)
            .margin({ top: 10 })
            .onClick(() => {
              console.info('=== 调试信息 ===');
              console.info('当前歌曲索引:', this.currentSongIndex);
              console.info('当前歌曲:', this.songList[this.currentSongIndex].title);
              console.info('收藏状态数组:', this.songFavoriteStatus);
              console.info('当前歌曲收藏状态:', this.getCurrentSongFavorited());
              console.info('收藏总数:', this.favoriteManager.getFavoriteCount());
              console.info('所有收藏:', this.favoriteManager.getAllFavorites());
              console.info('播放器状态:', this.state);
              console.info('播放进度:', this.currentProgress, '/', this.duration);
            });

          // 播放器状态显示
          if (!this.isPlayerReady) {
            Text('播放器初始化中...')
              .fontSize(12)
              .fontColor('#FF0000')
              .margin({ top: 10 });
          }

          if (this.isLoading) {
            Text('正在加载收藏状态...')
              .fontSize(12)
              .fontColor('#FFA500')
              .margin({ top: 10 });
          }
        }
        .alignItems(HorizontalAlign.Center)
        .width('100%');
      }
      .width('100%')
      .padding({ top: 20 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF');
  }
}