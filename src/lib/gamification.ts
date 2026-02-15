export interface LevelInfo {
    level: number;
    currentXp: number;
    nextLevelXp: number | null;
    progress: number; // 0.0 to 1.0
}

const LEVEL_THRESHOLDS = [0, 50, 120, 220, 350];

/**
 * Returns the current level for a given amount of XP.
 */
export function getLevel(totalXpEarned: number): number {
    for (let i = LEVEL_THRESHOLDS.length - 1; i >= 0; i--) {
        if (totalXpEarned >= LEVEL_THRESHOLDS[i]) {
            return i + 1;
        }
    }
    return 1;
}

/**
 * Returns detailed progress information to the next level.
 */
export function getProgressToNextLevel(totalXpEarned: number): LevelInfo {
    const currentLevel = getLevel(totalXpEarned);
    const currentLevelIndex = currentLevel - 1;
    const nextLevelIndex = currentLevel;

    const currentLevelMinXp = LEVEL_THRESHOLDS[currentLevelIndex];
    const nextLevelMinXp =
        nextLevelIndex < LEVEL_THRESHOLDS.length
            ? LEVEL_THRESHOLDS[nextLevelIndex]
            : null;

    if (nextLevelMinXp === null) {
        return {
            level: currentLevel,
            currentXp: totalXpEarned,
            nextLevelXp: null,
            progress: 1.0,
        };
    }

    const xpInCurrentLevel = totalXpEarned - currentLevelMinXp;
    const xpNeededForNextLevel = nextLevelMinXp - currentLevelMinXp;
    const progress = Math.min(xpInCurrentLevel / xpNeededForNextLevel, 1.0);

    return {
        level: currentLevel,
        currentXp: totalXpEarned,
        nextLevelXp: nextLevelMinXp,
        progress: Math.max(0, progress),
    };
}
