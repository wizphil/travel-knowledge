# Make sure you're in the project root:
# cd ~/travel-knowledge

# Create folders
mkdir -p data/programs data/partners content/blog lib components app/"(pages)"/{programs,partners,associations,blog/[slug]}

# --- Data files ---
cat > data/programs/amex-mr.json <<'EOF'
{
  "id": "amex-mr",
  "name": "American Express Membership Rewards",
  "issuer": "American Express",
  "currency_name": "Membership Rewards Points",
  "website": "https://www.americanexpress.com/rewards"
}
EOF

cat > data/partners/air-france.json <<'EOF'
{
  "id": "air-france",
  "name": "Air France Flying Blue",
  "type": "airline",
  "region": "Europe",
  "website": "https://www.flyingblue.com"
}
EOF

cat > data/transfer_rules.json <<'EOF'
[
  {
    "program_id": "amex-mr",
    "partner_id": "air-france",
    "ratio": "1:1",
    "transfer_time_hours": 24,
    "transfer_bonus_history": [
      {
        "bonus_percent": 25,
        "start_date": "2024-06-01",
        "end_date": "2024-06-15"
      }
    ]
  }
]
EOF

# --- lib/types.ts ---
cat > lib/types.ts <<'EOF'
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
EOF

# --- lib/dataLoader.ts ---
cat > lib/dataLoader.ts <<'EOF'
import fs from "fs";
import path from "path";
import { Program, Partner, TransferRule } from "./types";

function loadJSON<T>(filePath: string): T {
  const full = path.join(process.cwd(), "data", filePath);
  return JSON.parse(fs.readFileSync(full, "utf8"));
}

export function getAllPrograms(): Program[] {
  const dir = path.join(process.cwd(), "data", "programs");
  return fs.readdirSync(dir).map((f) => loadJSON<Program>(`programs/${f}`));
}

export function getAllPartners(): Partner[] {
  const dir = path.join(process.cwd(), "data", "partners");
  return fs.readdirSync(dir).map((f) => loadJSON<Partner>(`partners/${f}`));
}

export function getTransferRules(): TransferRule[] {
  return loadJSON<TransferRule[]>("transfer_rules.json");
}

export function getJoinedData() {
  const programs = getAllPrograms();
  const partners = getAllPartners();
  const rules = getTransferRules();

  return rules.map((rule) => ({
    ...rule,
    program: programs.find((p) => p.id === rule.program_id),
    partner: partners.find((p) => p.id === rule.partner_id)
  }));
}
EOF

# --- app/(pages)/associations/page.tsx ---
cat > app/"(pages)"/associations/page.tsx <<'EOF'
import { getJoinedData } from "@/lib/dataLoader";

export default function AssociationsPage() {
  const data = getJoinedData();

  return (
    <main className="max-w-3xl mx-auto py-10">
      <h1 className="text-3xl font-semibold mb-6">Transfer Associations</h1>
      <ul className="space-y-4">
        {data.map((r, i) => (
          <li key={i} className="border p-4 rounded-lg shadow-sm bg-white">
            <p className="font-medium">
              {r.program?.name} → {r.partner?.name}
            </p>
            <p className="text-sm text-gray-600">
              Ratio: {r.ratio}, Transfer Time: {r.transfer_time_hours || "N/A"} hours
            </p>
            {r.transfer_bonus_history && (
              <ul className="text-sm mt-2">
                {r.transfer_bonus_history.map((b, j) => (
                  <li key={j}>
                    {b.bonus_percent}% bonus from {b.start_date} to {b.end_date}
                  </li>
                ))}
              </ul>
            )}
          </li>
        ))}
      </ul>
    </main>
  );
}
EOF

# --- Example blog post ---
cat > content/blog/example.mdx <<'EOF'
---
title: "How to Maximize Membership Rewards"
date: "2025-01-15"
---

American Express Membership Rewards points are valuable because they transfer to a wide variety of airline and hotel partners.

Here’s a quick tip: watch for transfer bonuses — they can often increase the value by **25–40%**!
EOF

echo "✅ All base folders and files created successfully."
