// 替换原导入语句
import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';


// 创建AVPlayer实例对象
let avPlayer: media.AVPlayer;
media.createAVPlayer().then((video: media.AVPlayer) => {
  if (video != null) {
    avPlayer = video;
    console.info('Succeeded in creating AVPlayer');
  } else {
    console.error('Failed to create AVPlayer');
  }
}).catch((error: BusinessError) => {
  console.error(`Failed to create AVPlayer, error message:${error.message}`);
});

@Entry
@Component
export struct MusicPage {
  // 状态变量
  @State isFavorited: boolean = false;
  @State backBtnScale: number = 1;
  @State searchBtnScale: number = 1;
  @State favBtnScale: number = 1;
  @State prevBtnScale: number = 1;
  @State playBtnScale: number = 1;
  @State nextBtnScale: number = 1;
  @State state: string = 'prepared'; // 播放状态
  @State duration: number = 0; // 音频时长
  @State angleNum: number = 0; // 专辑封面旋转角度
  @State currentProgress: number = 0; // 播放进度


  // 步骤4：注册AVPlayer回调函数
  setAVPlayerCallback(avPlayer: media.AVPlayer) {
    // 状态变化回调
    avPlayer.on('stateChange', async (state, reason) => {
      this.state = avPlayer.state;
      switch (state) {
        case 'initialized':
          // 准备播放并获取时长
          avPlayer.prepare().then(() => {
            this.duration = avPlayer.duration;
          });
          break;
        case 'prepared':
          // 开始播放（封面旋转）
          avPlayer.play().then(() => {
            this.angleNum = 360;
          });
          break;
      }
    });

    // 播放错误回调
    avPlayer.on('error', (err) => {
      console.error(`Error happened. Cause: ${JSON.stringify(err)}`);
    });

    // 播放进度回调
    avPlayer.on('timeUpdate', (time: number) => {
      if (avPlayer.state === 'completed') {
        // 播放完成重置状态
        this.currentProgress = 0;
        this.duration = 0;
        this.angleNum = 0;
      } else {
        this.currentProgress = time;
      }
    });
  }


  // 步骤3：加载HAP包资源文件
  async loadingResourceFile(avPlayer: media.AVPlayer) {
    // 获取资源文件的FD路径
    let context = getContext(this) as common.UIAbilityContext;
    let fileDir = await context.resourceManager.getRawFd("audioTest.mp3");
    // 设置播放源（触发initialized状态）
    avPlayer.fdSrc = fileDir;
  }


  // 步骤5：初始化AVPlayer
  async initAVPlayer() {
    // 注册回调 + 加载资源
    this.setAVPlayerCallback(avPlayer);
    await this.loadingResourceFile(avPlayer);
  }


  build() {
    Column() {
      // 标题栏
      Row() {
        Button() {
          Image($r('app.media.Music_back'))
            .width('60%')
            .height('60%')
            .scale({ x: this.backBtnScale, y: this.backBtnScale })
            .animation({ duration: 200, curve: Curve.EaseOut })
        }
        .width(40)
        .height(30)
        .backgroundColor('#F0F8FF')
        .borderRadius(15)
        .onClick(() => {
          this.backBtnScale = 0.8;
          setTimeout(() => this.backBtnScale = 1, 200);
        });

        Blank();
        Text('音乐').fontSize(20).fontWeight(FontWeight.Bold).fontColor('#222222');
        Blank();

        Button() {
          Image($r('app.media.Music_search'))
            .width('60%')
            .height('60%')
            .scale({ x: this.searchBtnScale, y: this.searchBtnScale })
            .animation({ duration: 200, curve: Curve.EaseOut })
        }
        .width(40)
        .height(30)
        .backgroundColor('#F0F8FF')
        .borderRadius(15)
        .onClick(() => {
          this.searchBtnScale = 0.8;
          setTimeout(() => this.searchBtnScale = 1, 200);
        });
      }
      .width('100%')
      .padding({ left: 15, right: 15, top: 20 });


      // 专辑封面（带旋转动画）
      Stack() {
        Image($r('app.media.Music_cover'))
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
        duration: this.duration,
        curve: Curve.Linear,
        iterations: -1, // 无限循环
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


      // 歌曲名称
      Text('七里香')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .margin({ top: 10 });


      // 播放控制区域（进度条 + 按钮）
      Column() {
        // 播放进度条（支持拖动跳转）
        Slider({
          value: this.currentProgress,
          min: 0,
          max: this.duration,
          style: SliderStyle.OutSet
        })
          .showTips(true)
          .width('90%')
          .margin({ bottom: 10 })
          .onChange((value: number) => {
            this.currentProgress = value;
            avPlayer.seek(value); // 拖动进度条跳转播放
          });


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
              .scale({ x: this.favBtnScale, y: this.favBtnScale })
              .animation({ duration: 200, curve: Curve.EaseOut })
          }
          .width(40)
          .height(40)
          .backgroundColor('transparent')
          .onClick(() => {
            this.isFavorited = !this.isFavorited;
            this.favBtnScale = 0.8;
            setTimeout(() => this.favBtnScale = 1, 200);
          });


          // 上一曲按钮
          Button() {
            Image($r('app.media.Music_prev'))
              .width('100%')
              .height('100%')
              .scale({ x: this.prevBtnScale, y: this.prevBtnScale })
              .animation({ duration: 200, curve: Curve.EaseOut })
          }
          .width(40)
          .height(40)
          .backgroundColor('transparent')
          .margin({ left: 30 })
          .onClick(() => {
            this.prevBtnScale = 0.8;
            setTimeout(() => this.prevBtnScale = 1, 200);
          });


          // 播放/暂停按钮（核心逻辑）
          Button() {
            Image(this.state === 'playing'
              ? $r('app.media.Music_play1')
              : $r('app.media.Music_pause')
            )
              .width('100%')
              .height('100%')
              .scale({ x: this.playBtnScale, y: this.playBtnScale })
              .animation({ duration: 200, curve: Curve.EaseOut })
          }
          .width(50)
          .height(50)
          .backgroundColor('transparent')
          .margin({ left: 30 })
          .onClick(async () => {
            this.playBtnScale = 0.8;
            setTimeout(() => this.playBtnScale = 1, 200);

            if (avPlayer) {
              if (this.state === 'paused' || this.state === 'completed') {
                // 继续播放
                avPlayer.play().then(() => {
                  this.state = 'playing';
                  this.angleNum = 360;
                });
              } else if (this.state === 'playing') {
                // 暂停播放
                avPlayer.pause().then(() => {
                  this.state = 'paused';
                  this.angleNum = 0;
                });
              } else {
                // 首次播放（初始化）
                await this.initAVPlayer();
              }
            }
          });


          // 下一曲按钮
          Button() {
            Image($r('app.media.Music_next'))
              .width('100%')
              .height('100%')
              .scale({ x: this.nextBtnScale, y: this.nextBtnScale })
              .animation({ duration: 200, curve: Curve.EaseOut })
          }
          .width(40)
          .height(40)
          .backgroundColor('transparent')
          .margin({ left: 30 })
          .onClick(() => {
            this.nextBtnScale = 0.8;
            setTimeout(() => this.nextBtnScale = 1, 200);
          });


          Text('单曲循环')
            .fontSize(14)
            .fontColor('#888888')
            .margin({ left: 30 });
        }
        .margin({ top: 10 })
        .width('90%')
        .justifyContent(FlexAlign.Center);
      }

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .padding({ bottom: 50 });
  }
}