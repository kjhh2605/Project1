import { mockProblem } from '@/entities/problem/model/mock-problem';
import { NeuCard } from '@/shared/ui/neu-card';

export function ProblemWorkspaceScreen() {
  return (
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: 18 }}>
      <NeuCard title={mockProblem.title} description={`난이도 ${mockProblem.level.toUpperCase()} · ${mockProblem.id}`}>
        <p style={{ marginTop: 0, color: 'var(--muted)', lineHeight: 1.6 }}>{mockProblem.prompt}</p>
        <div className="neu-inset" style={{ padding: 14, marginTop: 12 }}>
          <pre style={{ margin: 0, whiteSpace: 'pre-wrap', fontSize: 13 }}>{mockProblem.buggyCode}</pre>
        </div>
      </NeuCard>

      <div style={{ display: 'grid', gap: 18 }}>
        <NeuCard title="Diff Workspace" description="원본 대비 수정본을 비교하는 영역">
          <div className="neu-inset" style={{ padding: 12, minHeight: 180 }}>
            <p style={{ margin: 0, color: 'var(--muted)', fontSize: 14 }}>
              좌/우 Diff 에디터가 들어갈 위치. 현재는 UI 구조만 먼저 고정.
            </p>
          </div>
        </NeuCard>

        <NeuCard title="Fix Strategy" description="수정 전략 체크리스트">
          <ul style={{ margin: 0, paddingLeft: 18, display: 'grid', gap: 8 }}>
            {mockProblem.expectedFixHints.map((hint) => (
              <li key={hint} style={{ color: 'var(--muted)' }}>
                {hint}
              </li>
            ))}
          </ul>
        </NeuCard>
      </div>
    </div>
  );
}
