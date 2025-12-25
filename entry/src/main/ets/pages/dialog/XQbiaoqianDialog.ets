interface XQZiYuan{
  image : Resource
  label : string
}



@Preview
@CustomDialog
export default struct XQbiaoqianDialog{
  private XQList: XQZiYuan[] = [
    { image: $r('app.media.XQhappy'), label: '开心' },
    { image: $r('app.media.XQsad'), label: '伤心' },
    { image: $r('app.media.XQbaoxiao'), label: '爆笑' },
    { image: $r('app.media.XQliuhan'), label: '流汗' },
    { image: $r('app.media.Xqwuyu'), label: '无语' },
    { image: $r('app.media.XQgandong'), label: '感动' },
    { image: $r('app.media.XQku'), label: '想哭' },
    { image: $r('app.media.XQjingya'), label: '惊讶' },
    { image: $r('app.media.XQyaunqi'), label: '元气' },
  ];

  @State isXQOpen : boolean = false
  @State selectXQ : number = 0;

  controller : CustomDialogController


  build() {
    Column() {
      Image(this.XQList[this.selectXQ].image)
        .width(200)
        .height(200)
        .margin({top :20})
      
      Text(this.XQList[this.selectXQ].label)
        .fontSize(40)
        .fontWeight(FontWeight.Bold)
        .margin({top: 15})
      
      Row(){
        Button('← 上一个')
          .onClick(() => {
            this.selectXQ =(this.selectXQ -1 +this.XQList.length)
              % this.XQList.length;
        })



        Button('下一个 →')
          .onClick(() => {
            this.selectXQ =(this.selectXQ  + 1 +this.XQList.length)
              % this.XQList.length;
          })
      }.width("100%")
      .padding(20)
      .justifyContent(FlexAlign.SpaceBetween)

      
      
      
      







    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}