@Entry
@Component
export  struct Daka_page {
  @State message: string = 'Hello World';

  build() {
    Column(){
      Row(){
        Button("返回")
          .fontSize(15)
          .width(70)
          .height(30)
          .margin({ left: 15, top: 10 })
          .alignSelf(ItemAlign.Start)

        Text("记录心情")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 180, top: 8 })
          .alignSelf(ItemAlign.End)
      } .alignSelf(ItemAlign.Center)


      Divider()
        .strokeWidth(2)
        .color("black")
        .margin(10)
        .width("100%")

      Text("选择今日的心情标签")
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .padding(20)








    }
    .height('100%')
    .width('100%')
    .backgroundColor("#f3f3f3")
  }
}