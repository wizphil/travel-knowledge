export interface Program {
  id: string;
  name: string;
  issuer: string;
  currency_name: string;
  website: string;
}

export interface Partner {
  id: string;
  name: string;
  type: string;
  region: string;
  website: string;
}

export interface TransferRule {
  program_id: string;
  partner_id: string;
  ratio: string;
  transfer_time_hours?: number;
  transfer_bonus_history?: {
    bonus_percent: number;
    start_date: string;
    end_date: string;
  }[];
}
