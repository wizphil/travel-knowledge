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
