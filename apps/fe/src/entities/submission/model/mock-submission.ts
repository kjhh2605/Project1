export type SubmissionStatus = 'queued' | 'running' | 'analyzing' | 'ai_evaluating' | 'completed';

export type SubmissionEvent = {
  at: string;
  status: SubmissionStatus;
  note: string;
};

export type EvaluationSection = {
  title: string;
  score: number;
  summary: string;
};

export const mockSubmissionEvents: SubmissionEvent[] = [
  { at: '00:00', status: 'queued', note: '요청이 큐에 등록됨' },
  { at: '00:02', status: 'running', note: '샌드박스 실행 시작' },
  { at: '00:06', status: 'analyzing', note: '정적 분석 리포트 생성 중' },
  { at: '00:09', status: 'ai_evaluating', note: '루브릭 평가 진행 중' },
  { at: '00:13', status: 'completed', note: '최종 결과 저장 완료' }
];

export const mockEvaluationSections: EvaluationSection[] = [
  { title: 'Correctness', score: 82, summary: '엣지 케이스 일부가 누락됐지만 주요 시나리오를 통과한다.' },
  { title: 'Performance', score: 76, summary: '중복 조회 제거로 개선되었으나 정렬 비용 최적화 여지가 있다.' },
  { title: 'Readability', score: 88, summary: '의도 설명이 명확하고 함수 경계가 개선됐다.' },
  { title: 'Best Practices', score: 80, summary: '예외 처리와 로그 컨벤션을 보강하면 안정성이 높아진다.' }
];
