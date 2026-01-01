import { router } from '@kit.ArkUI';
import { FavoriteManager } from './FavoriteManager';
import { Song } from './SongModel';
import { common } from '@kit.AbilityKit';
@Entry
@Component
export struct FavoritesPage {
  @State favoriteSongs: Song[] = [];
  @State isLoading: boolean = false;

  private favoriteManager: FavoriteManager = FavoriteManager.getInstance();

  aboutToAppear() {
    // 获取 context 并设置给收藏管理器
    let context = getContext(this) as common.UIAbilityContext;
    if (context) {
      this.favoriteManager.setContext(context);
    }

    this.loadFavoriteSongs();
  }

  // 加载收藏的歌曲
  loadFavoriteSongs() {
    this.isLoading = true;
    this.favoriteSongs = this.favoriteManager.getAllFavorites();
    this.isLoading = false;
    console.info('加载收藏歌曲:', this.favoriteSongs.length);
  }

  // 移除收藏
  async removeFavorite(song: Song) {
    try {
      await this.favoriteManager.removeFavorite(song.id);
      this.loadFavoriteSongs(); // 重新加载列表
      console.info(`已取消收藏: ${song.title}`);
    } catch (error) {
      console.error('取消收藏失败:', error);
    }
  }

  // 清空所有收藏
  async clearAllFavorites() {
    try {
      await this.favoriteManager.clearFavorites();
      this.favoriteSongs = [];
      console.info('已清空所有收藏');
    } catch (error) {
      console.error('清空收藏失败:', error);
    }
  }

  // 播放歌曲 - 修改这个方法
  playSong(song: Song) {
    console.info(`播放歌曲: ${song.title} (ID: ${song.id})`);

    // 携带歌曲ID返回音乐页面
    router.pushUrl({
      url: 'pages/music/MusicPage',
      params: { songId: song.id }
    });
  }

  // 格式化时间
  formatTime(milliseconds?: number): string {
    if (!milliseconds) return '00:00';
    const totalSeconds = Math.floor(milliseconds / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Button() {
          Image($r('app.media.Music_back'))
            .width('60%')
            .height('60%')
        }
        .width(40)
        .height(30)
        .backgroundColor('#F0F8FF')
        .borderRadius(15)
        .onClick(() => {
          router.back();
        });

        Blank();
        Text('我的收藏')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222222');
        Blank();

        Button('清空', { type: ButtonType.Normal })
          .width(60)
          .height(30)
          .backgroundColor('#FF6B6B')
          .fontColor('#FFFFFF')
          .borderRadius(15)
          .onClick(() => {
            this.clearAllFavorites();
          });
      }
      .width('100%')
      .padding({ left: 15, right: 15, top: 20 });

      // 收藏数量统计
      Row() {
        Text(`共收藏 ${this.favoriteSongs.length} 首歌曲`)
          .fontSize(16)
          .fontColor('#666666');
      }
      .width('100%')
      .padding({ left: 20, top: 10, bottom: 10 })
      .backgroundColor('#F8F9FA');

      // 收藏列表
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(50)
            .height(50);
          Text('加载中...')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 10 });
        }
        .width('100%')
        .height('60%')
        .justifyContent(FlexAlign.Center);
      } else if (this.favoriteSongs.length === 0) {
        Column() {
          Image($r('app.media.Music_prev'))
            .width(100)
            .height(100);
          Text('暂无收藏歌曲')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ top: 20 });
          Text('快去音乐页面收藏喜欢的歌曲吧！')
            .fontSize(14)
            .fontColor('#CCCCCC')
            .margin({ top: 10 });
        }
        .width('100%')
        .height('60%')
        .justifyContent(FlexAlign.Center);
      } else {
        List({ space: 10 }) {
          ForEach(this.favoriteSongs, (song: Song) => {
            ListItem() {
              Row() {
                // 专辑封面
                Image($r(song.cover))  // 注意：这里需要使用资源引用
                  .width(50)
                  .height(50)
                  .borderRadius(10)
                  .margin({ right: 15 });

                // 歌曲信息
                Column({ space: 3 }) {
                  Text(song.title)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis });

                  Text(song.artist)
                    .fontSize(14)
                    .fontColor('#666666')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis });

                  if (song.duration) {
                    Text(this.formatTime(song.duration))
                      .fontSize(12)
                      .fontColor('#999999');
                  }
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1);

                // 操作按钮
                Row() {

                  Button('取消', { type: ButtonType.Normal })
                    .width(60)
                    .height(30)
                    .backgroundColor('#FF6B6B')
                    .fontColor('#FFFFFF')
                    .borderRadius(15)
                    .margin({ left: 10 })
                    .onClick(() => {
                      this.removeFavorite(song);
                    });
                }
              }
              .width('100%')
              .padding(15)
              .backgroundColor('#FFFFFF')
              .borderRadius(10)
              .shadow({ radius: 2, color: '#000000', offsetX: 0, offsetY: 1 })
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 15, right: 15 })
        .divider({ strokeWidth: 0.5, color: '#EEEEEE' });
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5');
  }
}