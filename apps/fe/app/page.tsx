import Link from 'next/link';

const features = [
  {
    title: 'Diff 기반 디버깅',
    body: '원본과 수정본을 나란히 비교해 원인 분석과 수정 전략을 기록합니다.'
  },
  {
    title: '실행 + 정적분석',
    body: '제출 후 실행 검증과 정적 분석 결과를 한 흐름에서 확인할 수 있습니다.'
  },
  {
    title: 'AI 루브릭 평가',
    body: '정답 여부를 넘어 성능, 가독성, 베스트 프랙티스 품질까지 평가합니다.'
  },
  {
    title: '비용 통제형 운영',
    body: '캐시와 계층형 모델 전략으로 품질과 비용 사이의 균형을 유지합니다.'
  }
];

const flowSteps = [
  { title: '1. Solve', body: '문제를 열고 버그 원인을 추적합니다.' },
  { title: '2. Submit', body: '수정본을 제출하고 파이프라인에 태웁니다.' },
  { title: '3. Evaluate', body: '실행/분석/AI 결과를 통합 수신합니다.' },
  { title: '4. Improve', body: '피드백 기반으로 다음 수정 루프를 진행합니다.' }
];

export default function HomePage() {
  return (
    <main>
      <div className="landing">
        <section className="hero neu-surface">
          <div>
            <h1>Debugging Quality, Not Just Accepted.</h1>
            <p>
              Project1은 정답 통과 여부만 보지 않습니다. 문제 원인 파악, 수정 전략, 성능 개선 근거까지
              평가하는 디버깅 중심 학습 플랫폼입니다.
            </p>
            <div style={{ marginTop: 18, display: 'flex', gap: 10, flexWrap: 'wrap' }}>
              <Link className="neu-button" href="/problems/prob-101">
                Problem Workspace
              </Link>
              <button className="neu-button" type="button">
                View Architecture
              </button>
            </div>
          </div>

          <div className="hero-grid">
            <article className="hero-card neu-inset">
              <strong>Current Focus</strong>
              <p style={{ margin: '8px 0 0', color: 'var(--muted)', fontSize: 13 }}>
                Problem Factory 최소 생성 파이프라인 + 프론트 UI 설계
              </p>
            </article>
            <article className="hero-card neu-inset">
              <strong>Tracks</strong>
              <p style={{ margin: '8px 0 0', color: 'var(--muted)', fontSize: 13 }}>
                FE / PF / Platform 병렬 트랙으로 충돌 없이 작업
              </p>
            </article>
            <article className="hero-card neu-inset">
              <strong>Workflow</strong>
              <p style={{ margin: '8px 0 0', color: 'var(--muted)', fontSize: 13 }}>
                Issue → Branch → PR → Merge를 기본 규칙으로 운영
              </p>
            </article>
          </div>
        </section>

        <section className="section neu-surface">
          <h2>Learning Flow</h2>
          <div className="flow">
            {flowSteps.map((step) => (
              <article key={step.title} className="flow-step neu-inset">
                <strong>{step.title}</strong>
                <p>{step.body}</p>
              </article>
            ))}
          </div>
        </section>

        <section className="section neu-surface">
          <h2>Core Features</h2>
          <div className="feature-grid">
            {features.map((feature, index) => (
              <article key={feature.title} className="feature-item neu-inset feature-card" data-idx={index + 1}>
                <h3>{feature.title}</h3>
                <p>{feature.body}</p>
              </article>
            ))}
          </div>
        </section>

        <section className="cta neu-surface">
          <div>
            <h2 style={{ margin: 0, fontSize: 20 }}>Start With One Bug, Ship Better Thinking.</h2>
            <p style={{ marginTop: 8 }}>홈 UI는 MVP의 방향성과 작업 흐름을 한 화면에서 전달하도록 설계되었습니다.</p>
          </div>
          <button className="neu-button" type="button">
            Open Design Checklist
          </button>
        </section>
      </div>
    </main>
  );
}
