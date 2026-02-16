import { mockSubmissionEvents } from '@/entities/submission/model/mock-submission';
import { NeuCard } from '@/shared/ui/neu-card';

const statusColor: Record<string, string> = {
  queued: 'var(--warn)',
  running: 'var(--accent)',
  analyzing: '#6a5acd',
  ai_evaluating: '#8b5cf6',
  completed: 'var(--ok)'
};

export function SubmissionStatusScreen() {
  return (
    <NeuCard title="Submission Timeline" description="SSE 이벤트 기반 상태 추적 UI 설계안">
      <div style={{ display: 'grid', gap: 12 }}>
        {mockSubmissionEvents.map((event) => (
          <article
            key={`${event.at}-${event.status}`}
            className="neu-inset"
            style={{
              padding: 12,
              display: 'grid',
              gridTemplateColumns: '72px 1fr',
              gap: 12,
              alignItems: 'center'
            }}
          >
            <strong style={{ color: 'var(--muted)', fontSize: 13 }}>{event.at}</strong>
            <div>
              <p style={{ margin: 0, fontWeight: 700, color: statusColor[event.status] }}>{event.status}</p>
              <p style={{ margin: '4px 0 0', color: 'var(--muted)', fontSize: 13 }}>{event.note}</p>
            </div>
          </article>
        ))}
      </div>
    </NeuCard>
  );
}
