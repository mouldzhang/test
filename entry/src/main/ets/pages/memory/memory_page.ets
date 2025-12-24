@Entry
@Component
export struct MemoryPage {
  @State moodTagScale: number = 1;
  @State bgmScale: number = 1;
  @State searchScale: number = 1;
  @State manageScale: number = 1;
  @State expandScale: number = 1;

  build() {
    Column() {
      // 标题栏
      Row() {
        Blank();
        Text('心情记忆')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222222');
        Blank();
      }
      .width('100%')
      .padding({ left: 15, right: 15, top: 20, bottom: 30 });

      // 功能按钮区域（实现左上、右上、左下、右下布局）
      Stack() {
        // 1. 今日心情标签（左上）
        Button() {
          Text('今日心情标签')
            .fontSize(14)
            .fontColor('#999999')
        }
        .width(120)
        .height(120)
        .backgroundColor('#E0E0E0')
        .borderRadius(60)
        .scale({ x: this.moodTagScale, y: this.moodTagScale })
        .animation({ duration: 200, curve: Curve.EaseOut })
        .position({ left: 40, top: 20 }) // 左上定位
        .onClick(() => {
          this.moodTagScale = 0.8;
          setTimeout(() => this.moodTagScale = 1, 200);
        });

        // 2. 今日播放最多bgm（右上）
        Button() {
          Text('今日播放最多bgm')
            .fontSize(14)
            .fontColor('#999999')
        }
        .width(150)
        .height(40)
        .backgroundColor('#E0E0E0')
        .borderRadius(20)
        .scale({ x: this.bgmScale, y: this.bgmScale })
        .animation({ duration: 200, curve: Curve.EaseOut })
        .position({ right: 40, top: 40 }) // 右上定位
        .onClick(() => {
          this.bgmScale = 0.8;
          setTimeout(() => this.bgmScale = 1, 200);
        });

        // 3. 心情搜索（左下）
        Button() {
          Text('心情搜索')
            .fontSize(12)
            .fontColor('#999999')
        }
        .width(80)
        .height(80)
        .backgroundColor('#E0E0E0')
        .borderRadius(40)
        .scale({ x: this.searchScale, y: this.searchScale })
        .animation({ duration: 200, curve: Curve.EaseOut })
        .position({ left: 60, bottom: 40 }) // 左下定位
        .onClick(() => {
          this.searchScale = 0.8;
          setTimeout(() => this.searchScale = 1, 200);
        });

        // 4. 歌单管理（右下）
        Button() {
          Text('歌单管理')
            .fontSize(14)
            .fontColor('#999999')
        }
        .width(120)
        .height(40)
        .backgroundColor('#E0E0E0')
        .borderRadius(5)
        .scale({ x: this.manageScale, y: this.manageScale })
        .animation({ duration: 200, curve: Curve.EaseOut })
        .position({ right: 40, bottom: 60 }) // 右下定位
        .onClick(() => {
          this.manageScale = 0.8;
          setTimeout(() => this.manageScale = 1, 200);
        });
      }
      .width('100%')
      .height('50%');

      // 心情记录区域
      Stack() {
        // 从左往右排列：用Row嵌套文本
        Row() { // space控制“日期”和“心情”的间距
          Column() {
            Text('9月1号 心情')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#222222');
            Text('今天很开心')
              .fontSize(14)
              .fontColor('#666666');
          }
        }
        .margin({ top: 15, left: 15 });

        Button() {
          Text('展开')
            .fontSize(12)
            .fontColor('#000000')
        }
        .width(40)
        .height(25)
        .backgroundColor('#7FFF7F')
        .borderRadius(12)
        .scale({ x: this.expandScale, y: this.expandScale })
        .animation({ duration: 200, curve: Curve.EaseOut })
        .position({ right: 15, top: 15 })
        .onClick(() => {
          this.expandScale = 0.8;
          setTimeout(() => this.expandScale = 1, 200);
        });
      }
      .width('90%')
      .height('40%')
      .backgroundColor('#C9C9C9')
      .borderRadius(10)
      .margin({ top: 20 });

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .padding({ bottom: 50 });
  }
}