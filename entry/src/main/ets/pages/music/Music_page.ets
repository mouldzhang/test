@Entry
@Component
export struct Music_page {
  @State message: string = "music";

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('Music_pageHelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome';
        })
    }
    .height('100%')
    .width('100%')
    .backgroundColor("#f3f3f3")
  }
}