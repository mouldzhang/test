import { XQZiYuan } from '../types';



@Preview
@CustomDialog
export default struct XQbiaoqianDialog{

   onConfirm : (selected :XQZiYuan) =>void =()=>{};

  private XQList: XQZiYuan[] = [
    { image: $r('app.media.XQhappy'), imageName:"XQhappy",label: '开心' },
    { image: $r('app.media.XQsad'), imageName:"XQsad",label: '伤心' },
    { image: $r('app.media.XQbaoxiao'), imageName:"XQbaoxiao",label: '爆笑' },
    { image: $r('app.media.XQliuhan'), imageName:"XQliuhan",label: '流汗' },
    { image: $r('app.media.Xqwuyu'), imageName:"Xqwuyu",label: '无语' }, // 修正：XQwuyu → Xqwuyu
    { image: $r('app.media.XQgandong'), imageName:"XQgandong",label: '感动' },
    { image: $r('app.media.XQku'),imageName:"XQku", label: '想哭' },
    { image: $r('app.media.XQjingya'), imageName:"XQjingya",label: '惊讶' }, // 修正：XQjiangya → XQjingya
    { image: $r('app.media.XQyaunqi'),imageName:"XQyaunqi", label: '元气' }, // 修正：XQyuanqi → XQyaunqi
  ];

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
        }) .borderWidth(2)
          .borderColor("black")
          .backgroundColor(Color.Transparent)
          .fontColor("black")


        Button('下一个 →')
          .onClick(() => {
            this.selectXQ =(this.selectXQ  + 1 +this.XQList.length)
              % this.XQList.length;
          }) .borderWidth(2)
          .borderColor("black")
          .backgroundColor(Color.Transparent)
          .fontColor("black")


      }.width("100%")
      .padding(20)
      .justifyContent(FlexAlign.SpaceBetween)



      Button("确认选择")
        .width(200)
        .margin({top : 20})
        .borderWidth(2)
        .borderColor("black")
        .backgroundColor(Color.Transparent)
        .fontColor("black")
        .onClick(() => {
          console.log('选择心情',this.XQList[this.selectXQ].label);
          this.onConfirm(this.XQList[this.selectXQ]);
          this.controller.close();
        })
    }
    .borderWidth(3)
    .borderColor("#97F7FA")
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}