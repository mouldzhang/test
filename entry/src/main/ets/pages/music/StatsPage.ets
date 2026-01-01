// StatsPage.ets - 创建新的统计展示页面
import { router } from '@kit.ArkUI';

// 定义明确的类类型
class SongInfoClass {
  title: string = '';
  artist: string = '';

  constructor(title: string = '', artist: string = '') {
    this.title = title;
    this.artist = artist;
  }
}

class MostPlayedSongClass {
  songId: number = 0;
  playCount: number = 0;

  constructor(songId: number = 0, playCount: number = 0) {
    this.songId = songId;
    this.playCount = playCount;
  }
}

@Entry
@Component
struct StatsPage {
  @State mostPlayedSong: MostPlayedSongClass | null = null;
  @State songInfo: SongInfoClass = new SongInfoClass();
  @State isLoading: boolean = true;

  // 获取歌曲信息的方法
  private getSongInfo(songId: number): SongInfoClass {
    const songInfoMap = new Map<number, SongInfoClass>([
      [1, new SongInfoClass('七里香', '周杰伦')],
      [2, new SongInfoClass('晴天', '周杰伦')],
      [3, new SongInfoClass('稻香', '周杰伦')],
      [4, new SongInfoClass('花海', '周杰伦')],
      [5, new SongInfoClass('青花瓷', '周杰伦')]
    ]);

    return songInfoMap.get(songId) || new SongInfoClass('未知歌曲', '未知歌手');
  }

  aboutToAppear() {
    this.isLoading = true;
    // 模拟1秒后加载完成
    setTimeout(() => {
      this.mostPlayedSong = new MostPlayedSongClass(1, 10);
      if (this.mostPlayedSong) {
        this.songInfo = this.getSongInfo(this.mostPlayedSong.songId);
      }
      this.isLoading = false;
    }, 1000);
  }

  build() {
    Column({ space: 10 }) {
      // 1. 标题栏
      Row() {
        Button() {
          Image($r('app.media.Music_back'))
            .width(24)
            .height(24)
        }
        .width(40)
        .height(40)
        .backgroundColor('#F0F8FF')
        .borderRadius(20)
        .onClick(() => {
          router.back();
        })

        Blank()

        Text('播放统计')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Blank()
      }
      .width('100%')
      .padding({ left: 16, right: 16 })

      // 2. 内容区域
      Column({ space: 20 }) {
        if (this.isLoading) {
          // 加载状态
          Column() {
            Text('加载中...')
              .fontSize(18)
              .fontColor('#666666')
          }
          .width('100%')
          .height('50%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else if (this.mostPlayedSong) {
          // 有数据状态
          this.BuildDataViewSimple()
        } else {
          // 无数据状态
          Column() {
            Image($r('app.media.Music_back'))
              .width(120)
              .height(120)

            Text('暂无播放记录')
              .fontSize(20)
              .fontColor('#999999')
              .margin({ top: 20 })

            Text('快去听歌吧！')
              .fontSize(16)
              .fontColor('#CCCCCC')
              .margin({ top: 10 })
          }
          .width('100%')
          .height('50%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .padding(20)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  // 简化版本，避免复杂的Builder内部逻辑
  @Builder
  BuildDataViewSimple() {
    // 注意：这里只包含UI组件代码
    Column({ space: 15 }) {
      // 顶部奖杯区域
      Column() {
        Image($r('app.media.Music_back'))
          .width(80)
          .height(80)

        Text('播放最多')
          .fontSize(18)
          .fontColor('#FF9800')
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 歌曲信息卡片
      Column() {
        // 排名徽章
        Row() {
          Text('1')
            .fontSize(26)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
        }
        .width(60)
        .height(60)
        .backgroundColor('#FF6B6B')
        .borderRadius(30)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)

        // 歌曲详情
        Column({ space: 10 }) {
          Text(this.songInfo.title)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')

          Text(this.songInfo.artist)
            .fontSize(16)
            .fontColor('#666666')

          Divider()
            .strokeWidth(1)
            .color('#E0E0E0')
            .margin({ top: 15, bottom: 15 })

          Row() {
            Text('播放次数：')
              .fontSize(16)
              .fontColor('#666666')

            Text(this.mostPlayedSong!.playCount.toString())
              .fontSize(24)
              .fontColor('#4A90E2')
              .fontWeight(FontWeight.Bold)
          }
        }
        .padding(20)
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .width('85%')
        .margin({ top: 15 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
  }
}