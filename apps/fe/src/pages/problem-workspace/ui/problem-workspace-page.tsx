import { AppShell } from '@/shared/ui/app-shell';
import { ProblemWorkspaceScreen } from '@/widgets/problem-workspace/ui/problem-workspace-screen';

type ProblemWorkspacePageProps = {
  problemId: string;
};

export function ProblemWorkspacePage({ problemId }: ProblemWorkspacePageProps) {
  return (
    <AppShell
      title={`Problem Workspace · ${problemId}`}
      subtitle="원인 분석, 수정 전략, Diff 작업을 한 화면에서 진행"
      actions={<button className="neu-button">Create Submission</button>}
    >
      <ProblemWorkspaceScreen />
    </AppShell>
  );
}

export default function ProblemWorkspaceRoutePage() {
  return <ProblemWorkspacePage problemId="preview" />;
}
