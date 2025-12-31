import router from '@ohos.router'
import { MoodParams} from '../types';

const VALID_IMAGE_NAMES = [
  "XQhappy", "XQsad", "XQbaoxiao", "XQliuhan",
  "Xqwuyu", "XQgandong", "XQku", "XQjingya", "XQyaunqi"
];

@Entry
@Component
export  struct Home {
  @State message: string = 'Home';
  @State weekendday : string = ''
  @State selectedMoodImage: Resource | null = null;
  @State selectedMoodLabel: string = "";

  @StorageProp("moodData") globalMoodData: MoodParams = {
    imageName: "",
    label: ""
  };

  @StorageProp("moodEventText") moodEventText: string = "发生心情事件记录";

  //星期获取组件
  aboutToAppear(){
    this.weekendday = this.getWeekday()
    this.syncMoodData();
  }
  getWeekday() : string{
    const weekdays = ['星期日', '星期一', '星期二', '星期三',
      '星期四', '星期五', '星期六'];
    return weekdays[new Date().getDay()]
  }

  syncMoodData() {
    console.log("Home 同步全局参数：", JSON.stringify(this.globalMoodData));
    if (this.globalMoodData.imageName && this.globalMoodData.label) {
      if (VALID_IMAGE_NAMES.includes(this.globalMoodData.imageName)) {
        this.selectedMoodLabel = this.globalMoodData.label;
        AppStorage.Set("moodData", this.globalMoodData);
        try {
          const resPath = `app.media.${this.globalMoodData.imageName}`;
          console.log("Home 加载资源路径：", resPath);
          this.selectedMoodImage = $r(resPath);
        } catch (e) {
          console.error("Home 资源加载失败：", e);
          this.selectedMoodImage = null;
          this.selectedMoodLabel = "";
        }
      } else {
        console.error("Home 非法资源名：", this.globalMoodData.imageName);
      }
    } else {
      this.selectedMoodLabel = "";
    }
  }

  onPageShow() {
    this.syncMoodData();
    this.moodEventText = AppStorage.Get("moodEventText") || "发生心情事件记录";
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Text('记录心情')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 1,top : 10})
            .alignSelf(ItemAlign.Start)

          Button("搜索昨天发生的事情")
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor("black")
            .margin({ left: 90})
            .alignSelf(ItemAlign.End)
            .backgroundColor(Color.Transparent)

            .onClick(()=>{
              // 核心修改：跳转至新建的百度搜索页面
              router.pushUrl({
                url: 'pages/baidu_page' // 路由路径和新建页面一致
              }).catch((error :Error) => {
                console.error("跳转百度失败：", error);
              });
            })
        }.width("100%")
        .margin({ top : 1})
        .justifyContent(FlexAlign.SpaceAround)

        // 以下原有代码完全不变，无需修改
        Divider()
          .strokeWidth(2)
          .color("black")
          .margin(10)
          .width("100%")

        if(this.selectedMoodImage){
          Image(this.selectedMoodImage)
            .width(200)
            .height(200)
            .margin({ top: 5 })
            .alignSelf(ItemAlign.Center)
            .gesture(
              TapGesture({ count: 1 })
                .onAction(() => {
                  router.pushUrl({
                    url: 'pages/Home/daka_page'
                  }).catch((error: Error) => {
                    console.error('路由跳转失败:', error.message);
                  });
                }))
        }else{
          Button('打卡')
            .width(200)
            .height(200)
            .fontSize(36)
            .fontColor("black")
            .fontWeight(FontWeight.Bold)
            .borderWidth(2)
            .borderColor("black")
            .backgroundColor(Color.Transparent)
            .borderRadius(100)
            .margin({ top: 2 })
            .alignSelf(ItemAlign.Center)
            .gesture(
              TapGesture({ count: 1 })
                .onAction(() => {
                  router.pushUrl({
                    url: 'pages/Home/daka_page'
                  }).catch((error: Error) => {
                    console.error('路由跳转失败:', error.message);
                  });
                })
            )
        }

        Row() {
          TextClock({timeZoneOffset : -8})
            .format('yy-MM-dd')
            .fontSize(20)
            .margin({ left: 10 })

          if(this.selectedMoodLabel){
            Text(this.selectedMoodLabel)
              .fontSize(25)
              .margin({ left: 45 })
              .fontWeight(FontWeight.Bold)
          }

          Text(this.weekendday)
            .fontSize(25)
            .margin({ left: 60 })
        }.width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .margin({ top: 30 })

        if(this.moodEventText) {
          Button(this.moodEventText)
            .width(360)
            .height(150)
            .fontColor("black")
            .borderWidth(2)
            .borderColor("black")
            .margin({ top: 10 })
            .alignSelf(ItemAlign.Center)
            .backgroundColor(Color.Transparent)
            .gesture(
              TapGesture({ count: 1 })
                .onAction(() => {
                  router.pushUrl({
                    url: 'pages/Home/EventPage'
                  }).catch((error: Error) => {
                    console.error('路由跳转失败:', error.message);
                  });
                })
            )
        }else{
          Button("发生心情事件记录")
            .width(360)
            .height(150)
            .fontColor("black")
            .borderWidth(2)
            .borderColor("black")
            .margin({ top: 10})
            .alignSelf(ItemAlign.Center)
            .backgroundColor(Color.Transparent)
            .gesture(
              TapGesture({ count: 2 })
                .onAction(() => {
                  router.pushUrl({
                    url: 'pages/Home/EventPage'
                  }).catch((error: Error) => {
                    console.error('路由跳转失败:', error.message);
                  });
                }))
        }
        Divider()
          .strokeWidth(2)
          .color("black")
          .width("100%")
          .margin({top: 30})

        Row() {
          Image($r('app.media.Music_show'))
            .width(80)
            .height(80)
            .opacity(1)

          Image($r('app.media.Music_s'))
            .width(60)
            .height(60)
            .opacity(1)

          Image($r('app.media.Music_play'))
            .width(60)
            .height(60)
            .opacity(1)

          Image($r('app.media.Music_x'))
            .width(60)
            .height(60)
            .opacity(1)
        }
        .width("100%")
        .margin({ left: 25 ,top: 20 })
        .alignSelf(ItemAlign.Center)
        .justifyContent(FlexAlign.SpaceEvenly)
      }
      .width('100%')
      .padding({ top: 25, bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.On)
    .backgroundColor("#f3f3f3")
  }
}