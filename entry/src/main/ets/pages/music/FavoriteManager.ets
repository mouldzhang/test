// FavoriteManager.ts
import { Song, createSong, LyricLine } from './SongModel';
import dataPreferences from '@ohos.data.preferences';
import { Context } from '@ohos.abilityAccessCtrl';

// 定义存储的歌曲数据类型
interface StoredSong {
  id: number;
  title: string;
  artist: string;
  fileName: string;
  cover: string;
  duration?: number;
  lyrics?: string;
}

export class FavoriteManager {
  private static instance: FavoriteManager;
  private favoriteSongs: Map<number, Song> = new Map();
  private readonly STORAGE_KEY = 'favorite_songs';
  private readonly PREFERENCES_NAME = 'my_favorite_preferences';
  private isInitialized: boolean = false;
  private preferences: dataPreferences.Preferences | null = null;
  private context: Context | null = null;

  // 添加事件监听器
  private listeners: ((songs: Song[]) => void)[] = [];

  private constructor() {}

  static getInstance(): FavoriteManager {
    if (!FavoriteManager.instance) {
      FavoriteManager.instance = new FavoriteManager();
    }
    return FavoriteManager.instance;
  }

  setContext(context: Context): void {
    if (this.context === null) {
      this.context = context;
    }
  }

  // 初始化Preference
  async initialize(): Promise<void> {
    if (this.isInitialized || !this.context) return;

    try {
      this.preferences = await dataPreferences.getPreferences(this.context, this.PREFERENCES_NAME);
      await this.loadFavorites();
      this.isInitialized = true;
    } catch (error) {
      console.error('初始化收藏管理器失败:', error);
    }
  }

  // 加载收藏歌曲
  private async loadFavorites(): Promise<void> {
    if (!this.preferences) return;

    try {
      const favoritesJson = await this.preferences.get(this.STORAGE_KEY, '[]') as string;
      const favorites: StoredSong[] = JSON.parse(favoritesJson);

      this.favoriteSongs.clear();

      favorites.forEach((songData: StoredSong) => {
        if (songData && songData.id && songData.title) {
          const song = createSong(
            songData.id,
            songData.title,
            songData.artist || '',
            songData.fileName || '',
            songData.cover || '',
            songData.lyrics || ''
          );

          if (songData.duration) {
            song.duration = songData.duration;
          }

          this.favoriteSongs.set(song.id, song);
        }
      });

      this.notifyListeners();
    } catch (error) {
      console.error('加载收藏歌曲失败:', error);
    }
  }

  // 添加收藏
  async addFavorite(song: Song): Promise<void> {
    await this.initialize();

    if (!this.preferences || !song) return;

    try {
      this.favoriteSongs.set(song.id, song);
      await this.saveFavorites();
      this.notifyListeners();
    } catch (error) {
      console.error('添加收藏失败:', error);
      throw new Error(`添加收藏失败: ${error.message}`);
    }
  }

  // 移除收藏
  async removeFavorite(songId: number): Promise<void> {
    await this.initialize();

    if (!this.preferences) return;

    try {
      this.favoriteSongs.delete(songId);
      await this.saveFavorites();
      this.notifyListeners();
    } catch (error) {
      console.error('移除收藏失败:', error);
      throw new Error(`移除收藏失败: ${error.message}`);
    }
  }

  // 保存收藏
  private async saveFavorites(): Promise<void> {
    if (!this.preferences) return;

    try {
      // 将 Song 对象转换为可存储的格式
      const favoritesArray: StoredSong[] = Array.from(this.favoriteSongs.values()).map((song: Song): StoredSong => {
        return {
          id: song.id,
          title: song.title,
          artist: song.artist,
          fileName: song.fileName,
          cover: song.cover,
          duration: song.duration,
          lyrics: this.serializeLyrics(song.lyrics)
        };
      })

      const favoritesJson = JSON.stringify(favoritesArray);
      await this.preferences.put(this.STORAGE_KEY, favoritesJson);
      await this.preferences.flush();
    } catch (error) {
      console.error('保存收藏失败:', error);
      throw new Error(`保存收藏失败: ${error.message}`);
    }
  }
  // 清空所有收藏
  async clearFavorites(): Promise<void> {
    await this.initialize();

    if (!this.preferences) return;

    try {
      this.favoriteSongs.clear();
      await this.saveFavorites();
      this.notifyListeners();
    } catch (error) {
      console.error('清空收藏失败:', error);
      throw new Error(`清空收藏失败: ${error.message}`);
    }
  }

  // 序列化歌词
  private serializeLyrics(lyrics?: LyricLine[]): string {
    if (!lyrics || lyrics.length === 0) return '';

    return lyrics.map(line => {
      const minutes = Math.floor(line.time / 60000);
      const seconds = Math.floor((line.time % 60000) / 1000);
      const milliseconds = line.time % 1000;
      return `[${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${milliseconds.toString().padStart(3, '0')}]${line.text}`;
    }).join('\n');
  }

  // 检查是否收藏
  isFavorite(songId: number): boolean {
    return this.favoriteSongs.has(songId);
  }

  // 获取所有收藏歌曲
  getAllFavorites(): Song[] {
    return Array.from(this.favoriteSongs.values());
  }

  // 添加监听器
  addListener(listener: (songs: Song[]) => void): void {
    this.listeners.push(listener);
  }

  // 移除监听器
  removeListener(listener: (songs: Song[]) => void): void {
    const index = this.listeners.indexOf(listener);
    if (index > -1) {
      this.listeners.splice(index, 1);
    }
  }

  // 通知监听器
  private notifyListeners(): void {
    const favorites = this.getAllFavorites();
    this.listeners.forEach(listener => {
      try {
        listener(favorites);
      } catch (error) {
        console.error('监听器通知失败:', error);
      }
    });
  }
}