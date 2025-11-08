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
