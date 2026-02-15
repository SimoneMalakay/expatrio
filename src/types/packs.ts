export type CountryCode = string;
export type Bloc = 'EU' | 'EEA' | 'CH' | 'UK';
export type LegalBasis =
  | 'employment'
  | 'self_employed'
  | 'student'
  | 'sufficient_resources'
  | 'family';

export interface Step {
  step_id: string;
  title: string;
  deadline: string | null;
  authority: string;
  requirements: string[];
  outcome: string;
  dependencies: string[]; // List of step_id
  xp: number;
  estimated_time_days: number | null;
  notes: string | null;
}

export interface Country {
  country_id: CountryCode;
  name: string;
  bloc: Bloc;
  has_exit_pack: boolean;
  has_destination_pack: boolean;
}

export interface DestinationPack {
  country_id: CountryCode;
  duration: 'more_than_90_days';
  common_steps: Step[];
  residency_bases: Record<
    LegalBasis,
    {
      basis_label: string;
      basis_steps: Step[];
    }
  >;
}

export interface ExitPack {
  country_id: CountryCode;
  exit_steps: Step[];
}

export interface Roadmap {
  roadmap_id: string;
  origin_country_id: CountryCode;
  destination_country_id: CountryCode;
  basis: LegalBasis;
  steps: Step[];
  total_xp: number;
  generated_at: string;
}
