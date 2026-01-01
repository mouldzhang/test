import preferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';
import router from '@ohos.router';
// import { SelectOption } from '@ohos.arkui.node'; // 导入SelectOption类型

interface MoodItem {
  icon: Resource;
  text: string;
}

interface StoreKey {
  GENDER: string;
  BIRTH_DATE: string;
  REGION: string;
  SIGNATURE: string;
  USER_NAME?: string; // 可选添加用户名存储键
}

const STORE_KEY: StoreKey = {
  GENDER: 'gender',
  BIRTH_DATE: 'birthDate',
  REGION: 'region',
  SIGNATURE: 'signature',
  USER_NAME: 'userName' // 如果需要存储用户名到Preferences，可以添加此项
};

@Entry
@Component
export struct My_Page {
  @Prop context?: Context;
  @State message: string = 'my';
  @State currentIndex: number = 0;
  @State showSidebar: boolean = false;
  @State currentTab: string = '心情';
  @State showEditDialog: boolean = false;

  // 个人信息状态变量
  @State gender: string = '男';
  @State birthDate: string = '12月23日';
  @State region: string = '冰岛';
  @State signature: string = '洗洗睡了！！！';

  // 编辑表单的临时变量
  @State editGender: string = '';
  @State editBirthDate: string = '';
  @State editRegion: string = '';
  @State editSignature: string = '';

  @StorageProp('currentLoginUserName') currentLoginUserName: string = '';
  @StorageProp('currentLoginAccount') currentLoginAccount: string = '';
  @StorageProp('currentLoginGender') currentLoginGender: string = '';
  // 性别选项 - 使用SelectOption数组
  private genderOptions: SelectOption[] = [
    { value: '男' },
    { value: '女' },
    { value: '保密' }
  ];

  // Toast相关状态
  @State toastMessage: string = '';
  @State showToastFlag: boolean = false;
  @State isSaving: boolean = false;

  private imageList: Resource[] = [
    $r('app.media.slidshow1'),
    $r('app.media.slidshow2'),
    $r('app.media.slidshow3'),
    $r('app.media.slidshow4')
  ];

  private moodList: MoodItem[] = [
    { icon: $r('app.media.startIcon'), text: '开心' },
    { icon: $r('app.media.startIcon'), text: '愉悦' },
    { icon: $r('app.media.startIcon'), text: '给你两刀' },
    { icon: $r('app.media.startIcon'), text: '来两个大嘴巴子' }
  ];

  private tabList: string[] = ['心情', '收藏'];

  // Preferences实例
  private prefs: preferences.Preferences | null = null;

  // 在组件即将显示时加载数据
  aboutToAppear() {
    this.loadUserData();
  }

  // 加载用户数据
  async loadUserData() {
    try {
      if (this.context) {
        this.prefs = await preferences.getPreferences(this.context, 'userProfile');

        // 从Preferences加载数据，如果没有则使用全局状态的数据
        const savedGender = await this.prefs.get(STORE_KEY.GENDER, this.currentLoginGender || '男');
        const savedBirthDate = await this.prefs.get(STORE_KEY.BIRTH_DATE, '1月1日');
        const savedRegion = await this.prefs.get(STORE_KEY.REGION, '中国');
        const savedSignature = await this.prefs.get(STORE_KEY.SIGNATURE, 'a住');

        this.gender = savedGender as string;
        this.birthDate = savedBirthDate as string;
        this.region = savedRegion as string;
        this.signature = savedSignature as string;

        // 如果Preferences中没有性别数据，但全局状态中有，则保存到Preferences
        if (!savedGender && this.currentLoginGender) {
          await this.prefs.put(STORE_KEY.GENDER, this.currentLoginGender);
          await this.prefs.flush();
          this.gender = this.currentLoginGender;
        }

        console.log('用户数据加载成功:', {
          gender: this.gender,
          birthDate: this.birthDate,
          region: this.region,
          signature: this.signature
        });
      }
    } catch (error) {
      console.error('加载用户数据失败:', error);
    }
  }

  // 保存用户数据到Preferences
  async saveUserData() {
    try {
      if (!this.prefs && this.context) {
        this.prefs = await preferences.getPreferences(this.context, 'userProfile');
      }

      if (this.prefs) {
        await this.prefs.put(STORE_KEY.GENDER, this.gender);
        await this.prefs.put(STORE_KEY.BIRTH_DATE, this.birthDate);
        await this.prefs.put(STORE_KEY.REGION, this.region);
        await this.prefs.put(STORE_KEY.SIGNATURE, this.signature);

        await this.prefs.flush();

        console.log('用户数据保存成功:', {
          gender: this.gender,
          birthDate: this.birthDate,
          region: this.region,
          signature: this.signature
        });
      }
    } catch (error) {
      console.error('保存用户数据失败:', error);
      // 修复问题①：不能抛出任意类型，只抛出Error对象
      throw new Error(String(error));
    }
  }

  // 关闭侧边栏
  closeSidebar() {
    this.showSidebar = false;
  }

  // 打开编辑资料对话框
  openEditDialog() {
    this.editGender = this.gender;
    this.editBirthDate = this.birthDate;
    this.editRegion = this.region;
    this.editSignature = this.signature;
    this.showEditDialog = true;
  }

  // 验证数据
  validateData(): boolean {
    if (!this.editGender || this.editGender.trim() === '') {
      this.showToast('请填写性别');
      return false;
    }

    if (!this.editBirthDate || this.editBirthDate.trim() === '') {
      this.showToast('请填写出生日期');
      return false;
    }

    if (!this.editRegion || this.editRegion.trim() === '') {
      this.showToast('请填写所在地区');
      return false;
    }

    if (!this.editSignature || this.editSignature.trim() === '') {
      this.showToast('请填写个性签名');
      return false;
    }

    return true;
  }

  // 保存编辑的资料
  async saveProfile() {
    if (!this.validateData()) {
      return;
    }

    this.isSaving = true;

    try {
      // 模拟网络请求延迟 - 修复问题②：显式指定类型
      await new Promise<void>((resolve) => {
        setTimeout(() => {
          resolve();
        }, 500);
      });

      this.gender = this.editGender.trim();
      this.birthDate = this.editBirthDate.trim();
      this.region = this.editRegion.trim();
      this.signature = this.editSignature.trim();

      await this.saveUserData();

      this.showEditDialog = false;
      this.showToast('资料保存成功！');
    } catch (error) {
      console.error('保存失败:', error);
      this.showToast('保存失败，请重试');
    } finally {
      this.isSaving = false;
    }
  }

  // 取消编辑
  cancelEdit() {
    if (!this.isSaving) {
      this.showEditDialog = false;
    }
  }

  // 显示Toast
  showToast(message: string) {
    this.toastMessage = message;
    this.showToastFlag = true;

    setTimeout(() => {
      this.showToastFlag = false;
    }, 3000);
  }

  // 跳转到首页
  navigateToHome() {
    this.closeSidebar();
    router.pushUrl({
      url: 'pages/Home/TabUIPage'
    }).catch((error: Error) => {
      console.error('跳转到首页失败:', error);
    });
  }

  // 跳转到登录页
  navigateToLogin() {
    this.closeSidebar();
    router.pushUrl({
      url: 'pages/login/login'
    }).catch((error: Error) => {
      console.error('跳转到登录失败:', error);
    });
  }

  build() {
    Stack() {
      // 主内容层
      Column() {
        // 顶部占1/3的图片轮播区域
        Stack({ alignContent: Alignment.BottomStart }) {
          Swiper() {
            ForEach(this.imageList, (imageRes: Resource, index: number) => {
              Stack() {
                Image(imageRes)
                  .width('100%')
                  .height('100%')
                  .objectFit(ImageFit.Cover)

                Row() {
                  // 蒙版区域
                }
                .width('100%')
                .height('100%')
                .backgroundColor('rgba(0, 0, 0, 0.4)')
              }
            }, (imageRes: Resource, index: number) => index.toString())
          }
          .width('100%')
          .height('100%')
          .autoPlay(true)
          .interval(5000)
          .indicator(true)
          .loop(true)
          .duration(1000)
          .onChange((index: number) => {
            this.currentIndex = index;
          })

          // 固定在轮播图左下角的头像和用户信息
          Row() {
            Stack() {
              Image($r('app.media.avatar'))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Cover)
                .clip(new Circle({ width: 60, height: 60 }))
            }
            .width(60)
            .height(60)
            .borderRadius(30)
            .border({ width: 2, color: Color.White })

            Column() {
              // 显示用户名（来自全局状态）
              Text(`用户名：${this.currentLoginUserName || '未设置'}`)
                .fontSize(14)
                .fontColor('#f0f0f0')
                .textAlign(TextAlign.Start)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ bottom: 2 })
              Text(`账 号：${this.currentLoginAccount || '未登录'}`)
                .fontSize(14)
                .fontColor('#f0f0f0')
                .textAlign(TextAlign.Start)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .margin({ left: 12 })
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Center)
          }
          .margin({ left: 24, bottom: 24 })
          .alignItems(VerticalAlign.Center)

          // 轮播图右上角的菜单按钮
          Row() {
            Blank()
            Column() {
              Image($r('app.media.sanhengxian'))
                .width(40)
                .height(40)
                .objectFit(ImageFit.Contain)
                .padding(5)
                .backgroundColor('rgba(0, 0, 0, 0.3)')
                .borderRadius(30)
                .onClick(() => {
                  this.showSidebar = !this.showSidebar;
                })
            }
            .alignItems(HorizontalAlign.End)
          }
          .width('100%')
          .height('100%')
          .alignItems(VerticalAlign.Top)
          .padding({ top: 28, right: 24 })
        }
        .width('100%')
        .height('33.33%')

        // 底部占2/3的核心内容区域
        Column() {
          // 1. 个人资料卡片区域
          Column() {
            // 1.1 性别/日期/地区标签行
            Row() {
              Text(this.gender)
                .fontSize(14)
                .fontColor(Color.White)
              Text('|')
                .fontSize(14)
                .fontColor(Color.White)
                .margin({ left: 4, right: 4 })
              Text(this.birthDate)
                .fontSize(14)
                .fontColor(Color.White)
              Text('|')
                .fontSize(14)
                .fontColor(Color.White)
                .margin({ left: 4, right: 4 })
              Text(this.region)
                .fontSize(14)
                .fontColor(Color.White)
            }
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('#4A90E2')
            .borderRadius(4)
            .margin({ bottom: 8 })

            // 1.2 个性签名
            Text(`个性签名：${this.signature}`)
              .fontSize(14)
              .fontColor('#333333')
              .margin({ bottom: 12 })
              .textAlign(TextAlign.Start)
              .width('100%')

            // 1.3 编辑资料按钮
            Button('编辑资料')
              .width('100%')
              .height(40)
              .backgroundColor('#E5E5E5')
              .fontSize(14)
              .fontColor('#666666')
              .borderRadius(4)
              .border({ width: 0 })
              .onClick(() => {
                this.openEditDialog();
              })
          }
          .width('90%')
          .padding({ top: 16, bottom: 16, left: 16, right: 16 })
          .backgroundColor(Color.White)
          .borderRadius(8)
          .margin({ top: 16, bottom: 16 })
          .alignItems(HorizontalAlign.Start)

          // 2. 标签栏
          Row() {
            ForEach(this.tabList, (tab: string) => {
              Column() {
                Text(tab)
                  .fontSize(16)
                  .fontColor(this.currentTab === tab ? '#4A90E2' : '#666666')
                  .fontWeight(this.currentTab === tab ? FontWeight.Bold : FontWeight.Normal)
                if (this.currentTab === tab) {
                  Divider()
                    .width(20)
                    .height(2)
                    .backgroundColor('#4A90E2')
                    .margin({ top: 4 })
                }
              }
              .onClick(() => {
                this.currentTab = tab;
              })
              .flexGrow(1)
              .alignItems(HorizontalAlign.Center)
            })
          }
          .width('90%')
          .height(44)
          .backgroundColor(Color.White)
          .borderRadius(4)
          .margin({ bottom: 12 })

          // 3. 标签内容区域
          Stack() {
            if (this.currentTab === '心情') {
              Grid() {
                ForEach(this.moodList, (item: MoodItem, index: number) => {
                  GridItem() {
                    Column() {
                      Image(item.icon)
                        .width(24)
                        .height(24)
                        .margin({ bottom: 8 })
                      Text(item.text)
                        .fontSize(14)
                        .fontColor('#333333')
                    }
                    .width('100%')
                    .height(80)
                    .justifyContent(FlexAlign.Center)
                    .alignItems(HorizontalAlign.Center)
                    .backgroundColor(Color.White)
                    .border({ width: 1, color: '#EEEEEE' })
                  }
                })
              }
              .width('90%')
              .columnsTemplate('1fr 1fr')
              .columnsGap(1)
              .rowsGap(1)
              .backgroundColor('#EEEEEE')
            } else {
              Text(`暂无${this.currentTab}相关内容`)
                .fontSize(14)
                .fontColor('#999999')
                .padding(20)
            }
          }
        }
        .width('100%')
        .height('66.67%')
        .backgroundColor('#F5F5F5')
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
      }
      .height('100%')
      .width('100%')
      .backgroundColor("#f3f3f3")

      // 侧边栏遮罩层
      if (this.showSidebar) {
        Stack() {
          Column() {
            Blank()
          }
          .width('30%')
          .height('100%')
          .onClick(() => {
            this.closeSidebar();
          })

          Column() {
            Row() {
              Image($r('app.media.sanhengxian'))
                .width(35)
                .height(35)
                .onClick(() => {
                  this.closeSidebar();
                })
              Blank()
              Text('菜单')
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .margin({ top: 50, bottom: 30 })
            .padding({ left: 20, right: 20 })

            MyMenuItem({
              icon: $r('app.media.shouye'),
              text: '首页',
              onItemClick: () => {
                this.navigateToHome();
              }
            })

            MyMenuItem({
              icon: $r('app.media.tuichu'),
              text: '退出登录',
              onItemClick: () => {
                this.navigateToLogin();
              }
            })

            MyMenuItem({ icon: $r('app.media.geren'), text: '个人资料' })
            MyMenuItem({ icon: $r('app.media.lishi'), text: '历史记录' })
            MyMenuItem({ icon: $r('app.media.bangzhu'), text: '帮助与反馈' })
            MyMenuItem({ icon: $r('app.media.erweim'), text: '我的二维码' })
            MyMenuItem({ icon: $r('app.media.huancun'), text: '清理缓存' })
            MyMenuItem({ icon: $r('app.media.shezhi'), text: '设置' })
            MyMenuItem({ icon: $r('app.media.zhangh'), text: '切换账号' })
          }
          .width('70%')
          .height('100%')
          .backgroundColor(Color.White)
          .position({ x: '30%' })
          .shadow({ radius: 10, color: '#40000000', offsetX: -2 })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#60000000')
        .position({ x: 0, y: 0 })
      }

      // 编辑资料对话框
      if (this.showEditDialog) {
        Stack() {
          // 半透明背景遮罩层
          Column() {
            Blank()
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#60000000')
          .onClick(() => {
            if (!this.isSaving) {
              this.cancelEdit();
            }
          })

          // 编辑表单弹窗
          Column() {
            // 标题栏
            Row() {
              Text('编辑资料')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
              Blank()
              Image($r('app.media.close'))
                .width(20)
                .height(20)
                .onClick(() => {
                  if (!this.isSaving) {
                    this.cancelEdit();
                  }
                })
            }
            .width('100%')
            .padding({ bottom: 16 })

            // 表单内容
            Column({ space: 16 }) {
              // 性别选择 - 修复问题③：使用SelectOption数组
              // 性别选择 - 使用按钮替代
              Column() {
                Text('性别')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ bottom: 8 })
                  .textAlign(TextAlign.Start)
                  .width('100%')

                Row({ space: 10 }) {
                  ForEach(['男', '女', '保密'], (gender: string) => {
                    Button(gender)
                      .fontSize(14)
                      .backgroundColor(this.editGender === gender ? '#4A90E2' : '#F5F5F5')
                      .fontColor(this.editGender === gender ? Color.White : '#333333')
                      .borderRadius(4)
                      .onClick(() => {
                        this.editGender = gender;
                      })
                  })
                }
                .width('100%')
                .height(40)
                .justifyContent(FlexAlign.SpaceBetween)
              }


              // 出生日期输入
              Column() {
                Text('出生日期')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ bottom: 8 })
                  .textAlign(TextAlign.Start)
                  .width('100%')
                TextInput({ text: this.editBirthDate, placeholder: '如: 12月23日' })
                  .width('100%')
                  .height(40)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(4)
                  .padding({ left: 12, right: 12 })
                  .onChange((value: string) => {
                    this.editBirthDate = value;
                  })
              }

              // 地区输入
              Column() {
                Text('所在地区')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ bottom: 8 })
                  .textAlign(TextAlign.Start)
                  .width('100%')
                TextInput({ text: this.editRegion, placeholder: '请输入所在地区' })
                  .width('100%')
                  .height(40)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(4)
                  .padding({ left: 12, right: 12 })
                  .onChange((value: string) => {
                    this.editRegion = value;
                  })
              }

              // 个性签名输入
              Column() {
                Text('个性签名')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ bottom: 8 })
                  .textAlign(TextAlign.Start)
                  .width('100%')
                TextInput({ text: this.editSignature, placeholder: '请输入个性签名' })
                  .width('100%')
                  .height(80)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(4)
                  .padding({ left: 12, right: 12 })
                  .onChange((value: string) => {
                    this.editSignature = value;
                  })
              }
            }
            .width('100%')

            // 按钮区域
            Row({ space: 12 }) {
              Button('取消')
                .flexGrow(1)
                .height(44)
                .backgroundColor('#E5E5E5')
                .fontSize(14)
                .fontColor('#666666')
                .borderRadius(4)
                .border({ width: 0 })
                .enabled(!this.isSaving)
                .onClick(() => {
                  this.cancelEdit();
                })

              Button(this.isSaving ? '保存中...' : '保存')
                .flexGrow(1)
                .height(44)
                .backgroundColor(this.isSaving ? '#CCCCCC' : '#4A90E2')
                .fontSize(14)
                .fontColor(Color.White)
                .borderRadius(4)
                .border({ width: 0 })
                .enabled(!this.isSaving)
                .onClick(() => {
                  this.saveProfile();
                })
            }
            .width('100%')
            .margin({ top: 24 })
          }
          .width('80%')
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .shadow({ radius: 10, color: '#40000000', offsetX: 0, offsetY: 2 })
        }
        .width('100%')
        .height('100%')
      }

      // Toast提示 - 修复问题④和⑤：移除pointerEvents，使用其他方式
      if (this.showToastFlag) {
        Column() {
          Blank()
          Text(this.toastMessage)
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('rgba(0, 0, 0, 0.7)')
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .borderRadius(20)
            .margin({ bottom: 100 })
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.End)
      }
    }
    .height('100%')
    .width('100%')
  }
}

interface MenuItem {
  icon: Resource;
  text: string;
  onItemClick?: () => void;
}

@Component
struct MyMenuItem {
  private icon: Resource = $r('app.media.startIcon');
  private text: string = '';
  private onItemClick?: () => void;

  build() {
    Row() {
      Image(this.icon)
        .width(24)
        .height(24)
        .margin({ right: 12 })
        .objectFit(ImageFit.Contain)

      Text(this.text)
        .fontSize(16)
        .fontColor('#333')

      Blank()
    }
    .width('100%')
    .padding({ top: 15, bottom: 15, left: 20, right: 20 })
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      console.log(`点击了菜单项: ${this.text}`);
      if (this.onItemClick) {
        this.onItemClick();
      }
    })
  }
}