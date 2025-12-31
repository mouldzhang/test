// LyricView.ets
import { LyricLine } from './SongModel';

@Component
export struct LyricView {
  @Prop lyrics: LyricLine[];
  @Prop currentTime: number = 0;
  @Prop isExpanded: boolean = false;

  @State currentLineIndex: number = -1;

  aboutToUpdate() {
    this.updateCurrentLine();
  }

  // 更新当前歌词行
  updateCurrentLine() {
    if (!this.lyrics || this.lyrics.length === 0) return;

    // 找到当前时间对应的歌词行
    let newIndex = -1;
    for (let i = this.lyrics.length - 1; i >= 0; i--) {
      if (this.currentTime >= this.lyrics[i].time) {
        newIndex = i;
        break;
      }
    }

    if (this.currentLineIndex !== newIndex) {
      this.currentLineIndex = newIndex;

      // 如果处于展开模式，可以在这里触发滚动
      // 注意：ArkUI中不能直接操作Scroll，可以通过状态控制
    }
  }

  build() {
    Column() {
      if (!this.lyrics || this.lyrics.length === 0) {
        // 没有歌词的情况
        Column() {
          Text('暂无歌词')
            .fontSize(16)
            .fontColor('#999999')

          Text('歌词文件加载中...')
            .fontSize(14)
            .fontColor('#CCCCCC')
            .margin({ top: 8 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else if (this.isExpanded) {
        // 展开模式：显示完整歌词
        Scroll() {
          Column({ space: 16 }) {
            ForEach(this.lyrics, (lyric: LyricLine, index: number) => {
              Column() {
                Text(lyric.text)
                  .fontSize(index === this.currentLineIndex ? 20 : 16)
                  .fontColor(index === this.currentLineIndex ? '#4A90E2' :
                    (index < this.currentLineIndex ? '#666666' : '#999999'))
                  .fontWeight(index === this.currentLineIndex ? FontWeight.Bold : FontWeight.Normal)
                  .textAlign(TextAlign.Center)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                if (index === this.currentLineIndex) {
                  Divider()
                    .color('#4A90E2')
                    .strokeWidth(1)
                    .margin({ top: 4 })
                }
              }
              .width('100%')
              .padding(8)
              .backgroundColor(index === this.currentLineIndex ? '#F0F8FF' : Color.Transparent)
              .borderRadius(8)
            })
          }
          .width('100%')
          .padding(16)
        }
        .scrollBar(BarState.Off)
      } else {
        // 折叠模式：只显示当前歌词
        Column({ space: 8 }) {
          // 上一行歌词
          if (this.currentLineIndex > 0) {
            Text(this.lyrics[this.currentLineIndex - 1].text)
              .fontSize(14)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }

          // 当前歌词
          Text(this.currentLineIndex >= 0 ? this.lyrics[this.currentLineIndex].text : '')
            .fontSize(18)
            .fontColor('#4A90E2')
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          // 下一行歌词
          if (this.currentLineIndex < this.lyrics.length - 1) {
            Text(this.lyrics[this.currentLineIndex + 1].text)
              .fontSize(14)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
        }
        .width('100%')
        .padding(16)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height(this.isExpanded ? 400 : 100)
  }
}