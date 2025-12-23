@Entry
@Component
export  struct Memory_page {
   @State message: string = 'memory';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('Memory_pageHelloWorld')
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