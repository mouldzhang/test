import { router } from '@kit.ArkUI'
@Entry
@Component
export struct Index {
  @State passwordState: boolean = false
  @State account: string = ''
  @State password: string = ''

  build() {
    Column() {
      // logo图标
      Image($r('app.media.Music_cover'))
        .width(250)
        .height(240)

      Row() {
        TextInput({
          placeholder: '请输入您的账号'
        })
          .layoutWeight(1)
          .backgroundColor('#fff')
          .onChange((value: string) => {
            this.account = value;
          })
      }
      .width('100%')
      .height(40)
      .backgroundColor('#fff')
      .borderRadius(20)

      // 手机号(输入框)
      TextInput({
        placeholder: '请输入您的密码'
      })
        .placeholderColor('#666')
        .height(40)
        .margin({ top: 20 })
        .width('100%')
        .backgroundColor('#fff')
        .borderRadius(20)
        .type(InputType.Password)
        .maxLength(9)
        .showPasswordIcon(true)
        .showPassword(this.passwordState)
        .onSecurityStateChange(((isShowPassword: boolean) => {
          // 更新密码显示状态
          console.info('isShowPassword', isShowPassword)
          this.passwordState = isShowPassword
        }))
        .onChange((value: string) => {
          this.password = value;
        })

      // 已阅读并同意
      Row() {
        Checkbox()
          .width(10)
          .margin({ top: 6 })
        // 一段文本中，有文本样式需要单独定制，Text包裹Span
        Text() {
          Span('我已经阅读同意')
          Span('《心情记录》').fontColor('#3274f6')
          Span('《心情记录用户服务协议》').fontColor('#3274f6')
          Span('未注册的手机号将自动创建心情记录账号')
        }
        .fontSize(12)
        .fontColor('#666')
        .lineHeight(20)
      }
      .alignItems(VerticalAlign.Top)
      .margin({ top: 20 })

      // 登录
      Button('登录')
        .width('100%')
        .backgroundColor('#c02839')
        .margin({ top: 20 })
        .onClick(() => {
          if (this.validateCredentials()) {
            this.navigateToNextPage();
          } else {
            console.error('账号或密码错误');
            // 这里可以添加一些提示信息给用户，比如弹出一个Toast或者AlertDialog
          }
        })

      // 新用户注册等链接
      Row({ space: 15 }) {
        Text('新用户注册').fontSize(14).fontColor('#666')
        Text('账号密码登录').fontSize(14).fontColor('#666')
        Text('无法登录').fontSize(14).fontColor('#666')
      }
      .margin({ top: 20 })

      // 填充组件：作用：填充空白区域 （像弹簧）
      Blank()

      Column() {
        Text('其他登录方式')
          .fontSize(14)
          .height(22)
          .fontColor('#666')
          .margin({ bottom: 10 })
        Row() {
          Image($r('app.media.Memory_qq')).width(30)
          Image($r('app.media.Memory_weiXin')).width(30).fillColor('#5ea14f')
          Image($r('app.media.Memory_telephone')).width(30).fillColor('#ac4e52')
          Image($r('app.media.Memory_weiBo')).width(30).fillColor('#5cacf3')
        }
        .margin({ bottom: 10 })
        .justifyContent(FlexAlign.SpaceAround)
        .width('100%')
      }
      .width('100%')
    }
    .padding(20)
    .width('100%')
    .height('100%')
  }

  validateCredentials(): boolean {
    // 这里写你的账号密码验证逻辑，例如：
    if (this.account === '123456' && this.password === '123456') {
      return true;
    } else {
      return false;
    }
  }

  navigateToNextPage() {
    router.pushUrl({ url: 'pages/TabUIPage' });
  }
}
