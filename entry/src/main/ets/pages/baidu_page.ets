import router from '@ohos.router';

@Entry
@Component
struct SearchBaiduPage {
  build() {
    Column() {
      // 顶部返回按纽
      Row() {
        Button("← 返回Home")
          .onClick(() => {
            router.back(); // 返回上一页（Home页面）
          })
          .fontColor(Color.Black)
          .backgroundColor(Color.Transparent)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .margin({ left: 10, top: 10 })

      Web({
        src: "https://www.baidu.com", // 百度官方URL
        controller: new WebController()
      })
        .width('100%')
        .height('90%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#f3f3f3")
  }
}