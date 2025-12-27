import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

// 歌曲数据接口
interface Song {
  id: number;
  title: string;
  artist: string;
  fileName: string; // 音频文件名
  cover: Resource; // 专辑封面资源
  duration?: number; // 音频时长（毫秒）
}

@Entry
@Component
export struct MusicPage {
  // AVPlayer实例 - 改为组件内部管理
  private avPlayer: media.AVPlayer | null = null;

  // 状态变量
  @State isFavorited: boolean = false;
  @State backBtnScale: number = 1;
  @State searchBtnScale: number = 1;
  @State favBtnScale: number = 1;
  @State prevBtnScale: number = 1;
  @State playBtnScale: number = 1;
  @State nextBtnScale: number = 1;
  @State state: string = 'idle'; // 播放状态
  @State duration: number = 0; // 音频时长
  @State angleNum: number = 0; // 专辑封面旋转角度
  @State currentProgress: number = 0; // 播放进度
  @State currentSongIndex: number = 0; // 当前播放的歌曲索引
  @State playMode: 'sequential' | 'random' | 'loop' = 'sequential'; // 播放模式
  @State isPlayerReady: boolean = false; // 播放器是否就绪

  // 歌曲列表 - 修正文件名
  private songList: Song[] = [
    {
      id: 1,
      title: '七里香',
      artist: '周杰伦',
      fileName: '七里香-周杰伦.mp3', // 确保这个文件在resources/rawfile目录下
      cover: $r('app.media.Music_cover')
    },
    {
      id: 2,
      title: '晴天',
      artist: '周杰伦',
      fileName: '晴天-周杰伦.mp3', // 修正文件名，去掉空格
      cover: $r('app.media.Music_cover')
    },
    {
      id: 3,
      title: '稻香',
      artist: '周杰伦',
      fileName: '稻香-周杰伦.mp3', // 确保文件存在
      cover: $r('app.media.Music_cover')
    },
    {
      id: 3,
      title: '花海',
      artist: '周杰伦',
      fileName: '花海-周杰伦.mp3', // 确保文件存在
      cover: $r('app.media.Music_cover')
    },
    {
      id: 3,
      title: '青花瓷.',
      artist: '周杰伦',
      fileName: '青花瓷.mp3', // 确保文件存在
      cover: $r('app.media.Music_cover')
    }
  ];

  // 组件初始化时创建AVPlayer
  aboutToAppear() {
    this.createAVPlayer();
  }

  // 组件销毁时释放资源
  aboutToDisappear() {
    this.releaseAVPlayer();
  }

  // 创建AVPlayer实例
  async createAVPlayer() {
    try {
      this.avPlayer = await media.createAVPlayer();
      if (this.avPlayer) {
        console.info('Succeeded in creating AVPlayer');
        this.setAVPlayerCallback();
        await this.loadCurrentSong();
        this.isPlayerReady = true;
      } else {
        console.error('Failed to create AVPlayer');
      }
    } catch (error) {
      console.error(`Failed to create AVPlayer, error message:${error.message}`);
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

    // 状态变化回调
    this.avPlayer.on('stateChange', async (state: string) => {
      console.info(`AVPlayer state changed to: ${state}`);
      this.state = state;

      switch (state) {
        case 'idle':
          console.info('AVPlayer is idle');
          break;

        case 'initialized':
          console.info('AVPlayer initialized');
          try {
            await this.avPlayer!.prepare();
            console.info('AVPlayer prepared');
          } catch (error) {
            console.error(`Prepare failed: ${error.message}`);
          }
          break;

        case 'prepared':
          console.info('AVPlayer prepared');
          this.duration = this.avPlayer!.duration;
          this.songList[this.currentSongIndex].duration = this.duration;
          console.info(`Duration: ${this.duration}ms`);
          break;

        case 'playing':
          console.info('AVPlayer is playing');
          this.angleNum = 360;
          break;

        case 'paused':
          console.info('AVPlayer is paused');
          break;

        case 'completed':
          console.info('AVPlayer completed');
          this.currentProgress = 0;
          this.angleNum = 0;
          this.onNext(); // 播放下一首
          break;

        case 'stopped':
          console.info('AVPlayer stopped');
          this.currentProgress = 0;
          this.angleNum = 0;
          break;

        case 'error':
          console.error('AVPlayer encountered an error');
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
      console.error(`AVPlayer error: ${error.message}, code: ${error.code}`);
    });
  }

  // 加载当前歌曲
  async loadCurrentSong() {
    if (!this.avPlayer) {
      console.error('AVPlayer is not initialized');
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
      console.info(`Loading song: ${fileName}`);

      // 获取资源文件的FD路径
      let context = getContext(this) as common.UIAbilityContext;
      let fileDir = await context.resourceManager.getRawFd(fileName);

      if (fileDir && fileDir.fd > 0) {
        console.info(`File loaded successfully, fd: ${fileDir.fd}`);
        this.avPlayer.fdSrc = fileDir;
      } else {
        console.error(`Failed to load file: ${fileName}`);
      }
    } catch (error) {
      console.error(`Error loading song: ${error.message}`);
    }
  }

  // 播放/暂停
  async togglePlayPause() {
    if (!this.avPlayer) {
      console.error('AVPlayer is not initialized');
      return;
    }

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
        // 如果播放器未就绪，重新加载当前歌曲
        await this.loadCurrentSong();
        await this.avPlayer.play();
        this.state = 'playing';
        this.angleNum = 360;
      }
    } catch (error) {
      console.error(`Play/Pause error: ${error.message}`);
    }
  }

  // 播放指定索引的歌曲
  async playSongAtIndex(index: number) {
    if (index < 0 || index >= this.songList.length) {
      console.error('Invalid song index');
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
          // 返回逻辑
        });

        Blank();
        Text('音乐').fontSize(20).fontWeight(FontWeight.Bold).fontColor('#222222');
        Blank();

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
          // 搜索逻辑
        });
      }
      .width('100%')
      .padding({ left: 15, right: 15, top: 20 });

      // 专辑封面（带旋转动画）
      Stack() {
        Image(this.songList[this.currentSongIndex].cover)
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

        Text(`${this.currentSongIndex + 1}/${this.songList.length}`)
          .fontSize(14)
          .fontColor('#888888')
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
            Image(this.isFavorited
              ? $r('app.media.Music_active_best')
              : $r('app.media.Music_normal')
            )
              .width('100%')
              .height('100%')
          }
          .width(40)
          .height(40)
          .backgroundColor('transparent')
          .onClick(() => {
            this.isFavorited = !this.isFavorited;
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

        // 调试信息（开发时可显示）
        if (!this.isPlayerReady) {
          Text('播放器初始化中...')
            .fontSize(12)
            .fontColor('#FF0000')
            .margin({ top: 10 });
        }
      }
      .width('100%')
      .padding({ top: 20 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF');
  }
}