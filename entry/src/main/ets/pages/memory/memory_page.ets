import XQbiaoqianDialog from '../dialog/XQbiaoqianDialog';
import { XQZiYuan, MoodParams } from '../types'; // 引入 MoodParams 类型
import web_webview from '@ohos.web.webview' // 若无需可删除
import { router } from '@kit.ArkUI';

const VALID_IMAGE_NAMES = [ // 复用 Home 页面的合法图片名称校验数组
  "XQhappy", "XQsad", "XQbaoxiao", "XQliuhan",
  "Xqwuyu", "XQgandong", "XQku", "XQjingya", "XQyaunqi"
];

@Entry
@Component
export struct MemoryPage {
  @State moodTagScale: number = 1;
  @State bgmScale: number = 1;
  @State searchScale: number = 1;
  @State manageScale: number = 1;
  @State expandScale: number = 1;

  // 核心1：绑定 AppStorage 中的全局心情事件文本，自动同步 Home 页面数据
  @StorageProp("moodEventText") globalMoodEventText: string = "暂无心情事件记录";
  // 核心2：绑定全局心情图片和标签（原有逻辑，保留不变）
  @StorageProp("moodData") globalMoodData: MoodParams = {
    imageName: "",
    label: ""
  };
  @State showMoodImage: Resource | null = null;
  @State showMoodLabel: string = "";

  // 页面即将显示时，同步心情图片和标签（原有逻辑，保留不变）
  aboutToAppear() {
    this.syncMoodDataFromGlobal();
  }

  // 同步全局心情图片和标签（原有逻辑，保留不变）
  syncMoodDataFromGlobal() {
    console.log("MemoryPage 同步全局心情数据：", JSON.stringify(this.globalMoodData));
    if (this.globalMoodData.imageName && this.globalMoodData.label) {
      if (VALID_IMAGE_NAMES.includes(this.globalMoodData.imageName)) {
        this.showMoodLabel = this.globalMoodData.label;
        try {
          const resPath = `app.media.${this.globalMoodData.imageName}`;
          this.showMoodImage = $r(resPath);
        } catch (e) {
          console.error("MemoryPage 心情图片加载失败：", e);
          this.showMoodImage = null;
          this.showMoodLabel = "";
        }
      } else {
        console.error("MemoryPage 非法心情图片名称：", this.globalMoodData.imageName);
        this.showMoodImage = null;
        this.showMoodLabel = "";
      }
    } else {
      console.log("MemoryPage 全局心情数据为空");
      this.showMoodImage = null;
      this.showMoodLabel = "";
    }
  }
  // 跳转到收藏页面
  navigateToFavorites() {
    router.pushUrl({
      url: 'pages/music/FavoritesPage'
    }).catch((error: Error) => {
      console.error('跳转失败:', error);
    });
  }

  // 页面显示时，重新同步数据（确保最新，原有逻辑+心情事件无需额外同步，@StorageProp自动更新）
  onPageShow() {
    this.syncMoodDataFromGlobal();
  }

  build() {
    Column() {
      // 标题栏（原有逻辑，保留不变）
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

      // 功能按钮区域（原有逻辑，保留不变）
      Stack() {
        if(this.showMoodImage) {
          Button() {
            Image(this.showMoodImage)
              .width(150)
              .height(150)
          }
          .width(120)
          .height(120)
          .backgroundColor(Color.Transparent)
          .borderRadius(60)
          .scale({ x: this.moodTagScale, y: this.moodTagScale })
          .animation({ duration: 200, curve: Curve.EaseOut })
          .position({ left: 40, top: 10 })
          .onClick(() => {
            this.moodTagScale = 0.8;
            setTimeout(() => this.moodTagScale = 1, 200);
          });
        }else {
          Button() {
            Text("暂无今日心情")
              .fontSize(20)
          }
          .width(120)
          .height(120)
          .backgroundColor('#E0E0E0')
          .borderRadius(60)
          .scale({ x: this.moodTagScale, y: this.moodTagScale })
          .animation({ duration: 200, curve: Curve.EaseOut })
          .position({ left: 40, top: 20 })
          .onClick(() => {
            this.moodTagScale = 0.8;
            setTimeout(() => this.moodTagScale = 1, 200);
          });
        }

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
        .position({ right: 40, top: 40 })
        .onClick(() => {
          this.bgmScale = 0.8;
          setTimeout(() => this.bgmScale = 1, 200);
        });

        if(this.showMoodLabel) {
          Button() {
            Text(this.showMoodLabel)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
          }
          .width(80)
          .height(80)
          .backgroundColor('#E0E0E0')
          .borderRadius(40)
          .scale({ x: this.searchScale, y: this.searchScale })
          .animation({ duration: 200, curve: Curve.EaseOut })
          .position({ left: 60, bottom: 40 })
          .onClick(() => {
            this.searchScale = 0.8;
            setTimeout(() => this.searchScale = 1, 200);
          });
        }else {
          Button() {
            Text("暂无今日心情标签")
              .fontSize(15)
          }
          .width(100)
          .height(100)
          .backgroundColor('#E0E0E0')
          .borderRadius(60)
          .scale({ x: this.searchScale, y: this.searchScale })
          .animation({ duration: 200, curve: Curve.EaseOut })
          .position({ left: 60, bottom: 40 })
          .onClick(() => {
            this.searchScale = 0.8;
            setTimeout(() => this.searchScale = 1, 200);
          });
        }

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
        .position({ right: 40, bottom: 60 })
        .onClick(() => {
          this.navigateToFavorites();
        })
      }
      .width('100%')
      .height('50%');

      // 核心修改：心情记录区域展示 Home 传递的心情事件文本
      Stack() {
        Row() {
          // 展示日期 + 心情事件文本
            Text('9月1号')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#222222');
            // 展示全局心情事件文本（有数据显示内容，无数据显示默认值）
            Text(this.globalMoodEventText)
              .fontSize(14)
              .fontColor('#666666')
              .margin({ top: 5 }); // 与日期保持小间距

        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .padding({ left: 15, right: 15, top: 15 })
        .alignSelf(ItemAlign.Start)
      }
      .width('90%')
      .height('40%')
      .backgroundColor('#C9C9C9')
      .borderRadius(10)
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .padding({ bottom: 50 });
  }
}