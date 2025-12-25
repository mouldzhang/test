import { ChangeLabelParams } from '../types';
@Preview
@CustomDialog
export default struct changeXQlabelDialog {
  controllerchanglabel : CustomDialogController

  @State inputValue: string = '';

  onConfirm: (result: ChangeLabelParams) => void = () => {};


  build() {
    Column({space : 8}) {
      Text("!今天心情！")
        .fontSize(18)
        .margin({top : 10})
        .fontWeight(FontWeight.Bold)
        .alignSelf(ItemAlign.Center)

      TextInput({placeholder : "具体描述你的心情"})
          .width(200)
          .height(60)
          .fontColor("black")
          .borderWidth(3)
          .borderColor("#FDE9B1")
          .margin({ top: 10})
          .alignSelf(ItemAlign.Center)
          .backgroundColor(Color.Transparent)
        .onChange((value :string) =>{
          this.inputValue = value;
        })

      Button("提交")
        .width(100)
        .onClick(()=>{
          console.log('输入的内容是：', this.inputValue);
          this.onConfirm({ XQlabel: this.inputValue });
          this.controllerchanglabel.close();
        })
      }
    .justifyContent(FlexAlign.Center)
    }

}