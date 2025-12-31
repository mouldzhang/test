// MusicPage.ets
import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { Song, createSong } from './SongModel';
import { FavoriteManager } from './FavoriteManager';
import { LyricView } from './LyricView';
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
  @State songFavoriteStatus: boolean[] = [];
  @State isLoading: boolean = false;
  @State isLyricExpanded: boolean = false;  // 添加这行！！！

  // 收藏管理器
  private favoriteManager: FavoriteManager = FavoriteManager.getInstance();

  // 歌曲列表
  private songList: Song[] = [
    createSong(1, '七里香', '周杰伦', '七里香-周杰伦.mp3', 'app.media.Music_cover',    `[00:00.00] 七里香 - 周杰伦
[00:10.00] 作词：方文山 作曲：周杰伦
[00:20.00] 窗外的麻雀 在电线杆上多嘴
[00:25.00] 你说这一句 很有夏天的感觉
[00:30.00] 手中的铅笔 在纸上来来回回
[00:35.00] 我用几行字形容你是我的谁
[00:40.00] 秋刀鱼的滋味 猫跟你都想了解
[00:45.00] 初恋的香味就这样被我们寻回
[00:50.00] 那温暖的阳光 像刚摘的鲜艳草莓
[00:55.00] 你说你舍不得吃掉这一种感觉`),
    createSong(2, '晴天', '周杰伦', '晴天-周杰伦.mp3', 'app.media.Music_cover',    `[00:00.00] 晴天 - 周杰伦
[00:10.00] 作词：周杰伦 作曲：周杰伦
[00:15.00] 故事的小黄花 从出生那年就飘着
[00:20.00] 童年的荡秋千 随记忆一直晃到现在
[00:25.00] Re So So Si Do Si La
[00:28.00] So La Si Si Si Si La Si La So
[00:32.00] 吹着前奏望着天空 我想起花瓣试着掉落
[00:38.00] 为你翘课的那一天 花落的那一天
[00:42.00] 教室的那一间 我怎么看不见`
    ),
    createSong(3, '稻香', '周杰伦', '稻香-周杰伦.mp3', 'app.media.Music_cover',
      `[00:00.00] 稻香 - 周杰伦
[00:10.00] 作词：周杰伦 作曲：周杰伦
[00:15.00] 对这个世界如果你有太多的抱怨
[00:20.00] 跌倒了就不敢继续往前走
[00:24.00] 为什么人要这么的脆弱 堕落
[00:29.00] 请你打开电视看看
[00:31.00] 多少人为生命在努力勇敢的走下去
[00:35.00] 我们是不是该知足
[00:37.00] 珍惜一切 就算没有拥有`),
    createSong(4, '花海', '周杰伦', '花海-周杰伦.mp3', 'app.media.Music_cover',    `[00:00.00] 花海 - 周杰伦
[00:10.00] 作词：古小力、黄淩嘉 作曲：周杰伦
[00:15.00] 静止了 所有的花开
[00:20.00] 遥远了 清晰了爱
[00:24.00] 天郁闷 爱却很喜欢
[00:29.00] 那时候 我不懂 这叫爱
[00:34.00] 你喜欢 站在那窗台
[00:38.00] 你好久 都没再来`
    ),
    createSong(5, '青花瓷', '周杰伦', '青花瓷.mp3', 'app.media.Music_cover',`[00:10.00] 作词：方文山 作曲：周杰伦
  [00:15.00] 素胚勾勒出青花笔锋浓转淡
  [00:20.00] 瓶身描绘的牡丹一如你初妆
  [00:25.00] 冉冉檀香透过窗心事我了然
  [00:30.00] 宣纸上走笔至此搁一半
  [00:35.00] 釉色渲染仕女图韵味被私藏
  [00:40.00] 而你嫣然的一笑如含苞待放
  [00:45.00] 你的美一缕飘散 去到我去不了的地方`
  )
  ];

  aboutToAppear() {
    let context = getContext(this) as common.UIAbilityContext;
    this.favoriteManager.setContext(context);
    this.initializeFavoriteStatus();
    this.createAVPlayer();
  }

  aboutToDisappear() {
    this.releaseAVPlayer();
  }

  // 初始化收藏状态
  async initializeFavoriteStatus() {
    this.isLoading = true;
    await new Promise<void>(resolve => setTimeout(resolve, 200));

    this.songFavoriteStatus = this.songList.map(song =>
    this.favoriteManager.isFavorite(song.id)
    );

    this.isLoading = false;
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
    if (this.isLoading) return;

    const song = this.songList[this.currentSongIndex];
    const currentStatus = this.songFavoriteStatus[this.currentSongIndex];

    try {
      if (currentStatus) {
        await this.favoriteManager.removeFavorite(song.id);
        this.songFavoriteStatus[this.currentSongIndex] = false;
      } else {
        await this.favoriteManager.addFavorite(song);
        this.songFavoriteStatus[this.currentSongIndex] = true;
      }
      this.songFavoriteStatus = [...this.songFavoriteStatus];
    } catch (error) {
      console.error('收藏操作失败:', error);
    }
  }


  // 创建AVPlayer实例
  async createAVPlayer() {
    try {
      this.avPlayer = await media.createAVPlayer();
      if (this.avPlayer) {
        this.setAVPlayerCallback();
        await this.loadCurrentSong();
        this.isPlayerReady = true;
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
    }
  }

  // 注册AVPlayer回调函数
  setAVPlayerCallback() {
    if (!this.avPlayer) return;

    this.avPlayer.on('stateChange', async (state: string) => {
      this.state = state;

      switch (state) {
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
          break;
        case 'playing':
          this.angleNum = 360;
          break;
        case 'paused':
          break;
        case 'completed':
          this.currentProgress = 0;
          this.angleNum = 0;
          this.onNext();
          break;
        case 'stopped':
          this.currentProgress = 0;
          this.angleNum = 0;
          break;
      }
    });

    this.avPlayer.on('timeUpdate', (time: number) => {
      if (this.avPlayer && this.state === 'playing') {
        this.currentProgress = time;
      }
    });

    this.avPlayer.on('error', (error: BusinessError) => {
      console.error(`播放器错误: ${error.message}`);
    });
  }

  // 加载当前歌曲
  async loadCurrentSong() {
    if (!this.avPlayer) return;

    try {
      if (this.state === 'playing' || this.state === 'paused') {
        await this.avPlayer.stop();
      }

      await this.avPlayer.reset();

      const fileName = this.songList[this.currentSongIndex].fileName;
      let context = getContext(this) as common.UIAbilityContext;
      let fileDir = await context.resourceManager.getRawFd(fileName);

      if (fileDir && fileDir.fd > 0) {
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
    if (!this.avPlayer) return;

    try {
      if (this.state === 'playing') {
        await this.avPlayer.pause();
        this.state = 'paused';
        this.angleNum = 0;
      } else if (this.state === 'paused' || this.state === 'completed') {
        await this.avPlayer.play();
        this.state = 'playing';
        this.angleNum = 360;
      } else if (this.state === 'prepared' || this.state === 'initialized') {
        await this.avPlayer.play();
        this.state = 'playing';
        this.angleNum = 360;
      } else {
        await this.loadCurrentSong();
        await this.avPlayer.play();
        this.state = 'playing';
        this.angleNum = 360;
      }
    } catch (error) {
      console.error(`播放/暂停操作错误: ${error.message}`);
    }
  }

  // 播放指定索引的歌曲
  async playSongAtIndex(index: number) {
    if (index < 0 || index >= this.songList.length) return;

    this.currentSongIndex = index;
    this.currentProgress = 0;
    this.angleNum = 0;

    await this.loadCurrentSong();

    if (this.avPlayer && (this.state === 'playing' || this.state === 'paused')) {
      await this.avPlayer.play();
      this.state = 'playing';
      this.angleNum = 360;
    }
  }

  // 上一曲
  async onPrev() {
    let newIndex: number;

    switch (this.playMode) {
      case 'random':
        newIndex = Math.floor(Math.random() * this.songList.length);
        break;
      case 'loop':
        newIndex = this.currentSongIndex;
        break;
      case 'sequential':
      default:
        newIndex = this.currentSongIndex - 1;
        if (newIndex < 0) {
          newIndex = this.songList.length - 1;
        }
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
        break;
      case 'loop':
        newIndex = this.currentSongIndex;
        break;
      case 'sequential':
      default:
        newIndex = this.currentSongIndex + 1;
        if (newIndex >= this.songList.length) {
          newIndex = 0;
        }
        break;
    }

    await this.playSongAtIndex(newIndex);
  }

  // 切换播放模式
  togglePlayMode() {
    const modes: ('sequential' | 'random' | 'loop')[] = ['sequential', 'random', 'loop'];
    const currentIndex = modes.indexOf(this.playMode);
    this.playMode = modes[(currentIndex + 1) % modes.length];
  }

  // 获取播放模式显示文本
  getPlayModeText(): string {
    switch (this.playMode) {
      case 'sequential':
        return '顺序';
      case 'random':
        return '随机';
      case 'loop':
        return '循环';
      default:
        return '顺序';
    }
  }

  // 格式化时间显示
  formatTime(milliseconds: number): string {
    if (!milliseconds) return '00:00';
    const totalSeconds = Math.floor(milliseconds / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  }

  build() {
    Column({ space: 20 }) {

      // 标题栏
      Row() {

        // 歌词展开/折叠按钮
        Button() {
          Image(this.isLyricExpanded ?
            $r('app.media.Music_on') :
            $r('app.media.Music_off')
          )
            .width(24)
            .height(24)
        }
        .width(48)
        .height(48)
        .backgroundColor('#F0F8FF')
        .borderRadius(24)
        .onClick(() => {
          this.isLyricExpanded = !this.isLyricExpanded;
        })
        .margin({ left: 10 })

        Blank()

        Text('音乐播放器')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Blank()
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.SpaceBetween)

      // 专辑封面
      Stack() {
        Image($r(this.songList[this.currentSongIndex].cover))
          .width('100%')
          .height('100%')
          .borderRadius(100)
      }
      .width(200)
      .height(200)
      .borderRadius(100)
      .rotate({ angle: this.angleNum })
      .animation({
        duration: 10000,
        curve: Curve.Linear,
        iterations: -1
      })

      // 歌曲信息
      Column({ space: 8 }) {
        Text(this.songList[this.currentSongIndex].title)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Text(this.songList[this.currentSongIndex].artist)
          .fontSize(16)
          .fontColor('#666666')

        Row({ space: 8 }) {
          Text(`${this.currentSongIndex + 1}/${this.songList.length}`)
            .fontSize(14)
            .fontColor('#888888')

        }
      }
      .alignItems(HorizontalAlign.Center)

      // 在 MusicPage 的 build 方法中，修改歌词区域
      LyricView({
        lyrics: this.songList[this.currentSongIndex].lyrics || [],
        currentTime: this.currentProgress,
        isExpanded: this.isLyricExpanded
      })
        .width('90%')
        .height(this.isLyricExpanded ? 300 : 100)  // 展开时更高
        .backgroundColor('#FAFAFA')
        .borderRadius(8)


      // 进度条
      Column({ space: 8 }) {
        Slider({
          value: this.currentProgress,
          min: 0,
          max: this.duration || 1
        })
          .width('90%')
          .onChange((value: number) => {
            if (this.avPlayer && (this.state === 'playing' || this.state === 'paused')) {
              this.avPlayer.seek(value);
              this.currentProgress = value;
            }
          })

        Row() {
          Text(this.formatTime(this.currentProgress))
            .fontSize(14)
            .fontColor('#666666')

          Blank()

          Text(this.formatTime(this.duration))
            .fontSize(14)
            .fontColor('#666666')
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
      }

      // 播放控制按钮
      Row({ space: 20 }) {
        // 收藏按钮
        Button() {
          Image(this.getCurrentSongFavorited()
            ? $r('app.media.Music_active_best')
            : $r('app.media.Music_normal')
          )
            .width(24)
            .height(24)
        }
        .width(48)
        .height(48)
        .backgroundColor('#F0F8FF')
        .borderRadius(24)
        .onClick(() => {
          this.toggleFavorite();
        })

        // 上一曲
        Button() {
          Image($r('app.media.Music_prev'))
            .width(24)
            .height(24)
        }
        .width(48)
        .height(48)
        .backgroundColor('#F0F8FF')
        .borderRadius(24)
        .onClick(() => {
          this.onPrev();
        })

        // 播放/暂停
        Button() {
          Image(this.state === 'playing'
            ? $r('app.media.Music_play1')
            : $r('app.media.Music_pause')
          )
            .width(32)
            .height(32)
        }
        .width(64)
        .height(64)
        .backgroundColor('#4A90E2')
        .borderRadius(32)
        .onClick(() => {
          this.togglePlayPause();
        })

        // 下一曲
        Button() {
          Image($r('app.media.Music_next'))
            .width(24)
            .height(24)
        }
        .width(48)
        .height(48)
        .backgroundColor('#F0F8FF')
        .borderRadius(24)
        .onClick(() => {
          this.onNext();
        })

        // 播放模式
        Button() {
          Text(this.getPlayModeText())
            .fontSize(12)
            .fontColor('#666666')
        }
        .width(60)
        .height(32)
        .backgroundColor('#F5F5F5')
        .borderRadius(16)
        .onClick(() => {
          this.togglePlayMode();
        })
      }
      .justifyContent(FlexAlign.Center)

      // 状态显示
      if (!this.isPlayerReady) {
        Text('播放器初始化中...')
          .fontSize(14)
          .fontColor('#FF6B6B')
      }

      if (this.isLoading) {
        Text('加载中...')
          .fontSize(14)
          .fontColor('#666666')
      }
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#FFFFFF')
  }
}