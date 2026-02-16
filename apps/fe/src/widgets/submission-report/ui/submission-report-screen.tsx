import { mockEvaluationSections } from '@/entities/submission/model/mock-submission';
import { NeuCard } from '@/shared/ui/neu-card';

export function SubmissionReportScreen() {
  return (
    <div style={{ display: 'grid', gap: 18 }}>
      <NeuCard title="Execution Summary" description="실행/분석/AI 결과를 하나의 리포트로 합치는 화면">
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: 12 }}>
          <div className="neu-inset" style={{ padding: 12 }}>
            <p style={{ margin: 0, color: 'var(--muted)', fontSize: 12 }}>Runtime</p>
            <p style={{ margin: '6px 0 0', fontWeight: 800, fontSize: 22 }}>0.84s</p>
          </div>
          <div className="neu-inset" style={{ padding: 12 }}>
            <p style={{ margin: 0, color: 'var(--muted)', fontSize: 12 }}>Memory</p>
            <p style={{ margin: '6px 0 0', fontWeight: 800, fontSize: 22 }}>68 MB</p>
          </div>
          <div className="neu-inset" style={{ padding: 12 }}>
            <p style={{ margin: 0, color: 'var(--muted)', fontSize: 12 }}>Verdict</p>
            <p style={{ margin: '6px 0 0', fontWeight: 800, fontSize: 22, color: 'var(--ok)' }}>PASS</p>
          </div>
        </div>
      </NeuCard>

      <NeuCard title="AI Rubric" description="루브릭 기반 피드백 카드">
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(230px, 1fr))', gap: 12 }}>
          {mockEvaluationSections.map((section) => (
            <article key={section.title} className="neu-inset" style={{ padding: 14 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
                <h3 style={{ margin: 0, fontSize: 16 }}>{section.title}</h3>
                <strong style={{ fontSize: 20 }}>{section.score}</strong>
              </div>
              <p style={{ margin: '8px 0 0', color: 'var(--muted)', fontSize: 13, lineHeight: 1.5 }}>
                {section.summary}
              </p>
            </article>
          ))}
        </div>
      </NeuCard>
    </div>
  );
}
