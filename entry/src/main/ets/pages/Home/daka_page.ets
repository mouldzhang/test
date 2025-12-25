import router from '@ohos.router'
import changeXQlabelDialog from '../dialog/changeXQlabelDialog';
import XQbiaoqianDialog from '../dialog/XQbiaoqianDialog';

import { XQZiYuan,MoodParams,ChangeLabelParams } from '../types';


@Entry
@Component
export  struct Daka_page {

  @State weekendday : string = ""
  @State XQlabel: string = '';
  @State selectedXQ : XQZiYuan |null = null

  //星期组件
  aboutToAppear(){
    this.weekendday = this.getWeekday()
  }
  getWeekday() : string{
    const weekdays = ['星期日', '星期一', '星期二', '星期三',
      '星期四', '星期五', '星期六'];
    return weekdays[new Date().getDay()]
  }

  // 改变标签弹窗
  controllerchanglabel : CustomDialogController = new CustomDialogController({
    builder : changeXQlabelDialog({

      onConfirm: (result: ChangeLabelParams) => {
        this.XQlabel = result.XQlabel;
      }
      })
  })

  // 选择 心情弹窗
  controller  :  CustomDialogController = new CustomDialogController({
    builder :  XQbiaoqianDialog({
      onConfirm :(selected : XQZiYuan) =>{
        this.selectedXQ = selected;
        this.XQlabel = selected.label
      }
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


    if(this.selectedXQ){
      Image(this.selectedXQ.image)
        .width(150)
        .height(150)
        .onClick(()=>{
          this.controller.open()
        })
    }else {
      Button("选择心情")
        .width(150)
        .height(150)
        .fontSize(20)
        .fontColor("gray")
        .fontWeight(FontWeight.Bold)
        .borderWidth(2)
        .borderColor("black")
        .backgroundColor(Color.Transparent)
        .margin({ top: 5 })
        .alignSelf(ItemAlign.Center)
        .hoverEffect(HoverEffect.Highlight)
        .borderRadius(100)
        .onClick(()=>{
          this.controller.open()
        })
    }

      if (this.XQlabel){
        Text(this.XQlabel)
          .fontSize("25")
          .alignSelf(ItemAlign.Center)
          .padding(15)
          .hoverEffect(HoverEffect.Highlight)
      }else {
        Text()
          .fontSize("25")
          .alignSelf(ItemAlign.Center)
          .padding(15)
          .hoverEffect(HoverEffect.Highlight)

      }



      Button("描述你今天的心情")
        .width(150)
        .height(40)
        .padding(10)
        .alignSelf(ItemAlign.Center)
        .backgroundColor(Color.Transparent)
        .fontColor("black")
        .borderWidth(2)
        .onClick(()=>{
          this.controllerchanglabel.open()
        })


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
         .onClick(()=>{

           console.log("准备传递的参数：", {
             imageName: this.selectedXQ?.imageName,
             label: this.XQlabel
           });

           const moodData : MoodParams= {
             imageName: this.selectedXQ?.imageName || "",
             label: this.XQlabel || ""
           };

           router.back(
             // url :'page/Home/Home',
            1,moodData
           );


         })
    }
    .width('100%')
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.On)
    .backgroundColor("#f3f3f3")
  }
  }
