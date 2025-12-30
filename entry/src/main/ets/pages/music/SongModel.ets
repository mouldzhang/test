// SongModel.ts
export interface Song {
  id: number;
  title: string;
  artist: string;
  fileName: string;
  cover: string; // 存储资源ID字符串
  duration?: number;
}

// 对象复制辅助函数
export function copySong(song: Song): Song {
  return {
    id: song.id,
    title: song.title,
    artist: song.artist,
    fileName: song.fileName,
    cover: song.cover,
    duration: song.duration
  };
}

// 创建歌曲实例的函数
export function createSong(
  id: number,
  title: string,
  artist: string,
  fileName: string,
  coverId: string,
  duration?: number
): Song {
  return {
    id,
    title,
    artist,
    fileName,
    cover: coverId,
    duration
  };
}