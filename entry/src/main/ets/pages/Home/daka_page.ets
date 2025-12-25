import router from '@ohos.router'
import XQbiaoqianDialog from '../dialog/XQbiaoqianDialog';

@Entry
@Component
export  struct Daka_page {
  @State message: string = 'Hello World';
  @State weekendday : string = ""

  //星期组件
  aboutToAppear(){
    this.weekendday = this.getWeekday()
  }
  getWeekday() : string{
    const weekdays = ['星期日', '星期一', '星期二', '星期三',
      '星期四', '星期五', '星期六'];
    return weekdays[new Date().getDay()]
  }


  controllelr  :  CustomDialogController = new CustomDialogController({
    builder :  XQbiaoqianDialog({

    })
  })



  build() {
    Scroll() {
    Column({space : 8}){
      Row(){
        Button("返回")
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/TabUIPage'
            })
          })

          .fontSize(15)
          .width(70)
          .height(30)


        Text("记录心情")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceAround)



      Divider()
        .strokeWidth(2)
        .color("black")
        .margin(10)
        .width("100%")


      Row(){
        TextClock({timeZoneOffset : -8})
          .format('yy-MM-dd')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({left :20})

        Text(this.weekendday)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({left : 15})
      }.width('100%')
       .justifyContent(FlexAlign.SpaceEvenly)
      .padding({ right: 30 })
      .margin({ top: 10 })



      Button('标签')
        .width(150)
        .height(150)
        .fontSize(36)
        .fontColor("gray")
        .fontWeight(FontWeight.Bold)
        .borderWidth(2)
        .borderColor("black")
        .backgroundColor(Color.Transparent)
        .borderRadius(100)
        .margin({ top: 5 })
        .alignSelf(ItemAlign.Center)
        .hoverEffect(HoverEffect.Highlight)

      Text(this.message)
        .fontSize("25")
        .alignSelf(ItemAlign.Center)
        .padding(15)
        .hoverEffect(HoverEffect.Highlight)

      Button("描述你今天的心情")
        .width(150)
        .height(40)
        .padding(10)
        .alignSelf(ItemAlign.Center)
        .backgroundColor(Color.Transparent)
        .fontColor("black")
        .borderWidth(2)


      Divider()
        .strokeWidth(2)
        .color("black")
        .margin(10)
        .width("100%")


       Button("保存")
         .width(100)
         .height(60)
         .alignSelf(ItemAlign.Center)
         .backgroundColor(Color.Transparent)
         .fontColor("black")
         .borderWidth(2)
         .margin({top : 85})




    }
    .width('100%')


    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.On)
    .backgroundColor("#f3f3f3")


  }
  }
