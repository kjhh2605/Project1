import { AppShell } from '@/shared/ui/app-shell';
import { SubmissionStatusScreen } from '@/widgets/submission-status/ui/submission-status-screen';

type SubmissionStatusPageProps = {
  submissionId: string;
};

export function SubmissionStatusPage({ submissionId }: SubmissionStatusPageProps) {
  return (
    <AppShell
      title={`Submission Status · ${submissionId}`}
      subtitle="큐에서 완료까지의 상태를 실시간으로 확인"
      actions={<span className="neu-pill">SSE Connected</span>}
    >
      <SubmissionStatusScreen />
    </AppShell>
  );
}
