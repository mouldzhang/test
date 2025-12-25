import { Home } from './Home/Home';
import { MemoryPage } from './memory/memory_page';
import { MusicPage } from './music/Music_page';
import { My_Page } from './my/My_Page';

@Entry
@Component
struct TabUIPage {
  @State nowactivenumIndex : number =0

  @Builder tabBuilder(title : string, pagenumIndex : number, active_Image : Resource,normal_Image : Resource ){
    Column(){
      Image(this.nowactivenumIndex ===pagenumIndex  ?  active_Image :  normal_Image)
        .size({width : 25, height : 25})
      Text(title)
        .fontColor(this.nowactivenumIndex === pagenumIndex ? Color.Blue : Color.Gray)
    }
    .width("100%")
    .height("50")
    .justifyContent(FlexAlign.SpaceEvenly)
  }
// #哈哈

  build() {
    Column(){
      Tabs({ barPosition : BarPosition.End}){
//记录心情页面
       //主页面
        TabContent(){
          Home()
        }.tabBar(this.tabBuilder("心情记录", 0 ,$r('app.media.Home_active'),$r('app.media.Home')))



        TabContent() {
          MusicPage()
        }
        .tabBar(this.tabBuilder("音乐", 1, $r('app.media.music_active'), $r('app.media.music')))

        TabContent(){
          MemoryPage()
        }.tabBar(this.tabBuilder("心情回顾", 2 ,$r('app.media.memory_active'),$r('app.media.memory')))

        TabContent(){
          My_Page()
        }.tabBar(this.tabBuilder("我的", 3 ,$r('app.media.my_active'),$r('app.media.my')))

      }
      .onChange((index:number) =>{
        this.nowactivenumIndex = index
      })
      .backgroundColor("#D7EDA2")

    }
    .height('100%')
    .width('100%')
    .backgroundColor("#f3f3f3")
  }
}