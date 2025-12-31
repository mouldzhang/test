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

      // 核心：Web组件加载百度首页，实现搜索功能
      Web({
        src: "https://www.baidu.com", // 百度官方URL
        controller: new WebController() // Web控制器，用于控制页面跳转、刷新等
      })
        .width('100%')
        .height('90%') // 占满剩余页面高度
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#f3f3f3")
  }
}