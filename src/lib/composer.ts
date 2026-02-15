import {
    Roadmap,
    Step,
    DestinationPack,
    ExitPack,
    LegalBasis,
    CountryCode,
    Bloc,
} from '../types/packs';

// Mock loaders for the environment - in a real app, these would fetch JSON files
const loadDestinationPack = (id: string): DestinationPack | null => {
    // Implementation would use fs or fetch
    return null;
};

const loadExitPack = (id: string): ExitPack | null => {
    // Implementation would use fs or fetch
    return null;
};

export function composeRoadmap(input: {
    origin_country_id: string;
    destination_country_id: string;
    residency_basis: LegalBasis;
    citizenship_bloc: Bloc;
    flags?: { uk_withdrawal_agreement_beneficiary?: boolean };
}): Roadmap {
    const {
        origin_country_id,
        destination_country_id,
        residency_basis,
        citizenship_bloc,
        flags,
    } = input;

    const generatedAt = new Date().toISOString();
    const roadmapId = `rm_${origin_country_id}_${destination_country_id}_${residency_basis}_${Date.now()}`;

    // 1. Load destination pack
    const destination = loadDestinationPack(destination_country_id);

    // Error case: Destination not supported
    if (!destination) {
        return createErrorRoadmap(
            roadmapId,
            origin_country_id,
            destination_country_id,
            residency_basis,
            `Destination ${destination_country_id} not supported yet.`,
            generatedAt
        );
    }

    // 2. Logic for UK citizens
    if (citizenship_bloc === 'UK') {
        if (!flags?.uk_withdrawal_agreement_beneficiary) {
            return createErrorRoadmap(
                roadmapId,
                origin_country_id,
                destination_country_id,
                residency_basis,
                'UK non-WA citizens are not covered by this EU-scope dataset.',
                generatedAt
            );
        }
    }

    // 3. Load exit pack (optional)
    const exitPack = loadExitPack(origin_country_id);

    // 4. Merge steps in specific order
    let rawSteps: Step[] = [];

    // Order: Destination Common -> Basis Specific -> Exit Pack
    rawSteps = [...destination.common_steps];

    const basisData = destination.residency_bases[residency_basis];
    if (basisData) {
        rawSteps = [...rawSteps, ...basisData.basis_steps];
    }

    if (exitPack) {
        rawSteps = [...rawSteps, ...exitPack.exit_steps];
    }

    // 5. Deduplicate by step_id (keep first occurrence)
    const seenIds = new Set<string>();
    const uniqueSteps = rawSteps.filter((step) => {
        if (seenIds.has(step.step_id)) return false;
        seenIds.add(step.step_id);
        return true;
    });

    // 6. Topologically sort by dependencies
    const sortedSteps = topologicalSort(uniqueSteps);

    // 7. Compute total_xp
    const totalXp = sortedSteps.reduce((sum, step) => sum + step.xp, 0);

    return {
        roadmap_id: roadmapId,
        origin_country_id,
        destination_country_id,
        basis: residency_basis,
        steps: sortedSteps,
        total_xp: totalXp,
        generated_at: generatedAt,
    };
}

/**
 * Creates a Roadmap with a single informational/error step
 */
function createErrorRoadmap(
    id: string,
    origin: string,
    dest: string,
    basis: LegalBasis,
    message: string,
    timestamp: string
): Roadmap {
    return {
        roadmap_id: id,
        origin_country_id: origin,
        destination_country_id: dest,
        basis: basis,
        steps: [
            {
                step_id: 'error_notice',
                title: 'Information',
                deadline: null,
                authority: 'Expatrio System',
                requirements: [],
                outcome: message,
                dependencies: [],
                xp: 0,
                estimated_time_days: null,
                notes: null,
            },
        ],
        total_xp: 0,
        generated_at: timestamp,
    };
}

/**
 * Topologically sorts steps based on their dependencies
 */
function topologicalSort(steps: Step[]): Step[] {
    const stepMap = new Map<string, Step>();
    steps.forEach((s) => stepMap.set(s.step_id, s));

    const visited = new Set<string>();
    const result: Step[] = [];

    function visit(stepId: string) {
        if (visited.has(stepId)) return;

        const step = stepMap.get(stepId);
        if (!step) return; // Dependency not in this roadmap, skip

        // Mark as visiting to handle cycles if needed, 
        // but here we just ensure dependencies are processed first
        step.dependencies.forEach((depId) => {
            visit(depId);
        });

        visited.add(stepId);
        result.push(step);
    }

    steps.forEach((s) => visit(s.step_id));

    return result;
}
