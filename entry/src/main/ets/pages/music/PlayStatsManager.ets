import dataPreferences from '@ohos.data.preferences';
import { Context } from '@ohos.abilityAccessCtrl';

// 定义所有必要的接口
export interface PlayStat {
  songId: number;
  playCount: number;
  lastPlayed: number;
}

export interface MostPlayedSong {
  songId: number;
  playCount: number;
}

// 存储的单个记录
export interface StoredStatItem {
  key: number;  // 歌曲ID
  value: PlayStat;  // 统计信息
}

// 存储的完整数据结构
export interface StoredStats {
  items: StoredStatItem[];
}

export class PlayStatsManager {
  private static instance: PlayStatsManager | null = null;
  private stats: Map<number, PlayStat> = new Map<number, PlayStat>();
  private readonly STORAGE_KEY: string = 'play_stats';
  private readonly PREFERENCES_NAME: string = 'play_stats_preferences';
  private isInitialized: boolean = false;
  private preferences: dataPreferences.Preferences | null = null;
  private context: Context | null = null;

  private constructor() {}

  static getInstance(): PlayStatsManager {
    if (!PlayStatsManager.instance) {
      PlayStatsManager.instance = new PlayStatsManager();
    }
    return PlayStatsManager.instance;
  }

  setContext(context: Context): void {
    if (this.context === null) {
      this.context = context;
    }
  }

  // 初始化
  async initialize(): Promise<void> {
    if (this.isInitialized || !this.context) {
      return;
    }

    try {
      this.preferences = await dataPreferences.getPreferences(this.context, this.PREFERENCES_NAME);
      await this.loadStats();
      this.isInitialized = true;
    } catch (error) {
      console.error('初始化播放统计失败: ' + error.message);
    }
  }

  // 加载统计数据
  private async loadStats(): Promise<void> {
    if (!this.preferences) {
      return;
    }

    try {
      const statsJson: string = await this.preferences.get(this.STORAGE_KEY, '{"items":[]}') as string;
      const storedStats: StoredStats = JSON.parse(statsJson);

      this.stats.clear();

      if (storedStats.items && Array.isArray(storedStats.items)) {
        for (let i = 0; i < storedStats.items.length; i++) {
          const item: StoredStatItem = storedStats.items[i];
          this.stats.set(item.key, item.value);
        }
      }
    } catch (error) {
      console.error('加载播放统计失败: ' + error.message);
    }
  }

  // 记录一次播放
  async recordPlay(songId: number): Promise<void> {
    await this.initialize();

    if (!this.preferences) {
      return;
    }

    try {
      const currentStat: PlayStat | undefined = this.stats.get(songId);
      if (currentStat) {
        currentStat.playCount += 1;
        currentStat.lastPlayed = Date.now();
      } else {
        const newStat: PlayStat = {
          songId: songId,
          playCount: 1,
          lastPlayed: Date.now()
        };
        this.stats.set(songId, newStat);
      }

      await this.saveStats();
    } catch (error) {
      console.error('记录播放失败: ' + error.message);
    }
  }

  // 获取播放最多的歌曲
  getMostPlayedSong(): MostPlayedSong | null {
    if (this.stats.size === 0) {
      return null;
    }

    let maxSongId: number = 0;
    let maxCount: number = 0;

    this.stats.forEach((stat: PlayStat, songId: number) => {
      if (stat.playCount > maxCount) {
        maxCount = stat.playCount;
        maxSongId = songId;
      }
    });

    const result: MostPlayedSong = {
      songId: maxSongId,
      playCount: maxCount
    };
    return result;
  }

  // 获取所有统计数据
  getAllStats(): PlayStat[] {
    return Array.from(this.stats.values());
  }

  // 获取指定歌曲的统计
  getStat(songId: number): PlayStat | undefined {
    return this.stats.get(songId);
  }

  // 保存统计数据
  private async saveStats(): Promise<void> {
    if (!this.preferences) {
      return;
    }

    try {
      const items: StoredStatItem[] = [];

      this.stats.forEach((value: PlayStat, key: number) => {
        const item: StoredStatItem = {
          key: key,
          value: value
        };
        items.push(item);
      });

      const storedStats: StoredStats = {
        items: items
      };

      const statsJson: string = JSON.stringify(storedStats);
      await this.preferences.put(this.STORAGE_KEY, statsJson);
      await this.preferences.flush();
    } catch (error) {
      console.error('保存播放统计失败: ' + error.message);
    }
  }

  // 清除所有统计数据
  async clearStats(): Promise<void> {
    await this.initialize();

    if (!this.preferences) {
      return;
    }

    try {
      this.stats.clear();
      const emptyStats: StoredStats = { items: [] };
      await this.preferences.put(this.STORAGE_KEY, JSON.stringify(emptyStats));
      await this.preferences.flush();
    } catch (error) {
      console.error('清除统计失败: ' + error.message);
    }
  }
}