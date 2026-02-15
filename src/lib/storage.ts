export interface StepProgress {
    completed: boolean;
    completedAt: string | null;
}

export interface RoadmapProgress {
    roadmap_id: string;
    steps: Record<string, StepProgress>;
}

const STORAGE_KEY_PREFIX = 'expatrio_roadmap_progress_';

/**
 * Saves the progress for a specific roadmap to local storage.
 */
export function saveProgress(roadmapId: string, progress: RoadmapProgress): void {
    try {
        const key = `${STORAGE_KEY_PREFIX}${roadmapId}`;
        localStorage.setItem(key, JSON.stringify(progress));
    } catch (error) {
        console.error('Failed to save roadmap progress:', error);
    }
}

/**
 * Loads the progress for a specific roadmap from local storage.
 */
export function loadProgress(roadmapId: string): RoadmapProgress | null {
    try {
        const key = `${STORAGE_KEY_PREFIX}${roadmapId}`;
        const data = localStorage.getItem(key);
        if (!data) return null;
        return JSON.parse(data) as RoadmapProgress;
    } catch (error) {
        console.error('Failed to load roadmap progress:', error);
        return null;
    }
}

/**
 * Updates the completion status of a single step in a roadmap.
 */
export function setStepCompleted(
    roadmapId: string,
    stepId: string,
    completed: boolean
): void {
    let progress = loadProgress(roadmapId);

    if (!progress) {
        progress = {
            roadmap_id: roadmapId,
            steps: {},
        };
    }

    progress.steps[stepId] = {
        completed,
        completedAt: completed ? new Date().toISOString() : null,
    };

    saveProgress(roadmapId, progress);
}
