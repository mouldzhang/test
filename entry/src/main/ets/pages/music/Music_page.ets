@Entry
@Component
export struct MusicPage {
  // 收藏按钮状态：false=未收藏，true=已收藏
  @State isFavorited: boolean = false;
  // 播放状态：false=暂停，true=播放中
  @State isPlaying: boolean = false;

  // 每个按钮独立的缩放状态（解决联动动画问题）
  @State backBtnScale: number = 1;     // 返回按钮
  @State searchBtnScale: number = 1;   // 搜索按钮
  @State favBtnScale: number = 1;      // 收藏按钮
  @State prevBtnScale: number = 1;     // 上一曲按钮
  @State playBtnScale: number = 1;     // 播放/暂停按钮
  @State nextBtnScale: number = 1;     // 下一曲按钮

  build() {
    Column() {
      // 标题栏：返回 + 音乐标题 + 搜索
      Row() {
        // 返回按钮（独立动画）
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
          // 仅修改自身缩放状态
          this.backBtnScale = 0.8;
          setTimeout(() => this.backBtnScale = 1, 200);
        });

        Blank();

        Text('音乐')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222222');

        Blank();

        // 搜索按钮（独立动画）
        Button() {
          Image($r('app.media.Music_search'))
            .width('60%')
            .height('60%')
            .scale({ x: this.searchBtnScale, y: this.searchBtnScale })
            .animation({ duration: 200, curve: Curve.EaseOut })
        }
        .width(60)
        .height(30)
        .backgroundColor('#E6F7FF')
        .borderRadius(15)
        .onClick(() => {
          // 仅修改自身缩放状态
          this.searchBtnScale = 0.8;
          setTimeout(() => this.searchBtnScale = 1, 200);
        });
      }
      .width('100%')
      .padding({ left: 15, right: 15, top: 20 });

      // 专辑封面
      Stack() {
        Image($r('app.media.Music_cover'))
          .width('100%')
          .height('100%')
          .borderRadius(100)
      }
      .width(200)
      .height(200)
      .borderRadius(100)
      .margin({ top: 50 });

      // 歌词区域
      Stack() {
        Text('歌词')
          .fontSize(18)
          .fontColor('#666666');
      }
      .width('90%')
      .height(100)
      .backgroundColor('#FAFAFA')
      .border({ width: 1, color: '#E5E5E5' })
      .margin({ top: 30 });

      // 歌曲名称
      Text('七里香')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .margin({ top: 10 });

      // 播放控制栏
      Row() {
        // 收藏按钮（独立动画+状态切换）
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
          // 仅修改自身缩放状态
          this.favBtnScale = 0.8;
          setTimeout(() => this.favBtnScale = 1, 200);
        });

        // 上一曲按钮（独立动画）
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

        // 播放/暂停按钮（独立动画+状态切换）
        Button() {
          Image(this.isPlaying
            ? $r('app.media.Music_pause')
            : $r('app.media.Music_play1')
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
        .onClick(() => {
          this.isPlaying = !this.isPlaying;
          // 仅修改自身缩放状态
          this.playBtnScale = 0.8;
          setTimeout(() => this.playBtnScale = 1, 200);
        });

        // 下一曲按钮（独立动画）
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
      .margin({ top: 30 })
      .alignItems(VerticalAlign.Center);

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .padding({ bottom: 50 });
  }
}