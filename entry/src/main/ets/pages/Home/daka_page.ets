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
  });

  // 选择 心情弹窗
  controller  :  CustomDialogController = new CustomDialogController({
    builder :  XQbiaoqianDialog({
      onConfirm :(selected : XQZiYuan) =>{
        console.log("Daka_page 收到弹窗数据：", JSON.stringify(selected));
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
           // 1. 构造参数
           if(!this.selectedXQ){
             console.error("Daka_page：selectedXQ 为空！请先选择心情！");
             return; // 没选心情就不保存
           }

           // 2. 构造参数
           const moodData : MoodParams= {
             imageName: this.selectedXQ.imageName, // 不用 ||""，确保有值
             label: this.XQlabel
           };
           console.log("Daka_page 准备存储全局参数：", JSON.stringify(moodData));

           // 3. 强制存入 AppStorage（用 Set 确保覆盖旧数据）
           AppStorage.Set("moodData", moodData);

           // 5. 直接跳回 TabUIPage（比 back 更稳定）
           router.replaceUrl({ url: 'pages/TabUIPage' });
         });
    }
    .width('100%')
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.On)
    .backgroundColor("#f3f3f3")
  }
  }
