import router from '@ohos.router'

@Entry
@Component
struct EventPage {
  // 状态变量保留，用于存储输入内容
  @State moodEventInput: string = "";

  build() {
    Column({space:10}) {
      Row(){
        Button("← 返回")
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/TabUIPage'
            })
          })
          .fontColor(Color.Black)
          .backgroundColor(Color.Transparent)

        Button("往日事件")
          .onClick(() => {

          })
          .fontColor(Color.Black)
          .backgroundColor(Color.Transparent)

      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Text("记录心情事件时刻")
        .fontColor(Color.Black)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .width('100%')

      Divider()
        .color(Color.Black)
        .height(4)
        .margin({ top: 10, bottom: 10 })
        .width('100%')

      Text("今日心情：**")
        .fontColor(Color.Black)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .alignSelf(ItemAlign.Start)

      // 核心修复：移除 .value(this.moodEventInput)，仅保留 onChange 即可
      // 低版本 TextArea 无需 value 绑定，onChange 已能实时同步输入内容
      TextArea({placeholder:"请描述关于今天的心情事件"})
        .fontColor(Color.Black)
        .height(200)
        .backgroundColor("#dedfe0")
        .textAlign(TextAlign.Start)
        .padding({ left: 10, top: 5 })
        // 仅保留 onChange 事件，实时更新状态变量
        .onChange((value: string) => {
          this.moodEventInput = value;
        })

      Row(){
        Button("取消")
          .fontColor(Color.Black)
          .backgroundColor("#8b8c8f")
          .borderRadius(8)
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/TabUIPage'
            })
          })
        Button("确定")
          .fontColor(Color.Black)
          .backgroundColor("#81bffe")
          .borderRadius(8)
          .margin({ left: 50 })
          .onClick(() => {
            // 输入内容仍能正常存入 AppStorage
            AppStorage.Set("moodEventText", this.moodEventInput);
            console.log("EventPage 存入心情事件文本：", this.moodEventInput);
            router.replaceUrl({
              url: 'pages/TabUIPage'
            })
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}


