// SongModel.ets
export interface LyricLine {
  time: number;      // 时间戳（毫秒）
  text: string;      // 歌词文本
}

export interface Song {
  id: number;
  title: string;
  artist: string;
  fileName: string;
  cover: string;
  duration: number;
  lyrics?: LyricLine[];  // 添加歌词数据
}

// 解析歌词字符串为 LyricLine 数组
export function parseLyrics(lyricsString: string): LyricLine[] {
  if (!lyricsString) return [];

  const lines = lyricsString.split('\n');
  const lyricLines: LyricLine[] = [];

  for (const line of lines) {
    // 匹配格式: [mm:ss.xxx]歌词文本
    const match = line.match(/\[(\d{2}):(\d{2})\.(\d{2,3})\](.+)/);
    if (match && match.length >= 5) {
      const minutes = parseInt(match[1]);
      const seconds = parseInt(match[2]);
      const milliseconds = parseInt(match[3].padEnd(3, '0'));
      const time = minutes * 60000 + seconds * 1000 + milliseconds;
      lyricLines.push({
        time,
        text: match[4].trim()
      });
    }
  }

  // 按时间排序
  return lyricLines.sort((a, b) => a.time - b.time);
}

// 创建歌曲的示例，添加歌词数据
export function createSong(id: number, title: string, artist: string, fileName: string, cover: string, lyrics?: string): Song {
  return {
    id,
    title,
    artist,
    fileName,
    cover,
    duration: 0,
    lyrics: lyrics ? parseLyrics(lyrics) : []
  };
}