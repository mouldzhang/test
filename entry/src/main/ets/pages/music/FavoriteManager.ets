import { Song, copySong } from './SongModel';
import dataPreferences from '@ohos.data.preferences';
import { Context } from '@ohos.abilityAccessCtrl';

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
      console.info('收藏管理器 context 已设置');
    }
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

  // 通知所有监听器
  private notifyListeners(): void {
    const favorites = this.getAllFavorites();
    this.listeners.forEach(listener => listener(favorites));
  }

  private async init() {
    if (this.isInitialized) return;

    if (!this.context) {
      console.error('Context 未设置，无法初始化收藏管理器');
      return;
    }

    try {
      this.preferences = await dataPreferences.getPreferences(this.context, this.PREFERENCES_NAME);
      const data: string = await this.preferences.get(this.STORAGE_KEY, '{}') as string;
      const songsData: Record<string, Song> = JSON.parse(data);

      Object.keys(songsData).forEach((key: string) => {
        const songData: Song = songsData[key];
        this.favoriteSongs.set(songData.id, songData);
      });

      this.isInitialized = true;
      console.info('从存储加载收藏成功');
    } catch (error) {
      console.error('从存储加载收藏失败:', error);
      this.isInitialized = true;
    }
  }

  private async saveToStorage() {
    if (!this.preferences || !this.context) return;

    try {
      const songsObj: Record<string, Song> = {};
      this.favoriteSongs.forEach((song: Song, id: number) => {
        songsObj[id.toString()] = song;
      });

      await this.preferences.put(this.STORAGE_KEY, JSON.stringify(songsObj));
      await this.preferences.flush();

      // 保存后通知监听器
      this.notifyListeners();
    } catch (error) {
      console.error('保存收藏到存储失败:', error);
    }
  }

  async addFavorite(song: Song): Promise<void> {
    if (!this.isInitialized) {
      await this.init();
    }

    const songCopy = copySong(song);
    this.favoriteSongs.set(song.id, songCopy);
    await this.saveToStorage();
    console.info(`添加收藏成功: ${song.title}`);
  }

  async removeFavorite(songId: number): Promise<void> {
    if (!this.isInitialized) {
      await this.init();
    }

    this.favoriteSongs.delete(songId);
    await this.saveToStorage();
    console.info(`移除收藏成功: ${songId}`);
  }

  isFavorite(songId: number): boolean {
    if (!this.isInitialized) {
      console.warn('收藏管理器尚未初始化');
      return false;
    }

    return this.favoriteSongs.has(songId);
  }

  getAllFavorites(): Song[] {
    if (!this.isInitialized) {
      console.warn('收藏管理器尚未初始化');
      return [];
    }

    return Array.from(this.favoriteSongs.values());
  }

  getFavoriteCount(): number {
    if (!this.isInitialized) {
      console.warn('收藏管理器尚未初始化');
      return 0;
    }

    return this.favoriteSongs.size;
  }

  async clearFavorites(): Promise<void> {
    if (!this.isInitialized) {
      await this.init();
    }

    this.favoriteSongs.clear();
    await this.saveToStorage();
    console.info('清空收藏成功');
  }
}