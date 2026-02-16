export type Problem = {
  id: string;
  title: string;
  level: 'easy' | 'medium' | 'hard';
  prompt: string;
  buggyCode: string;
  expectedFixHints: string[];
};

export const mockProblem: Problem = {
  id: 'prob-101',
  title: 'Cache Miss Burst in User Ranking',
  level: 'medium',
  prompt:
    '사용자 랭킹 계산 함수에서 반복 쿼리와 캐시 무효화 타이밍 문제로 지연이 급증한다. 원인을 찾고 수정 전략을 적용해라.',
  buggyCode: `function rankUsers(users) {\n  return users.sort((a, b) => fetchScore(a.id) - fetchScore(b.id));\n}`,
  expectedFixHints: [
    '반복 I/O 호출 축소',
    '정렬 전 점수 선계산',
    '캐시 갱신 시점 분리'
  ]
};
