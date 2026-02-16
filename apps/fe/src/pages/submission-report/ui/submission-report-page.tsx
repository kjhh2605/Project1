import { AppShell } from '@/shared/ui/app-shell';
import { SubmissionReportScreen } from '@/widgets/submission-report/ui/submission-report-screen';

type SubmissionReportPageProps = {
  submissionId: string;
};

export function SubmissionReportPage({ submissionId }: SubmissionReportPageProps) {
  return (
    <AppShell
      title={`Submission Report · ${submissionId}`}
      subtitle="실행 성능, 정적 분석, AI 루브릭을 통합 리포트로 제공"
      actions={<button className="neu-button">Re-run Evaluation</button>}
    >
      <SubmissionReportScreen />
    </AppShell>
  );
}

export default function SubmissionReportRoutePage() {
  return <SubmissionReportPage submissionId="preview" />;
}
