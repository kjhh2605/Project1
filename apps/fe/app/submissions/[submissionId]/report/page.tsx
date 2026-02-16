import { SubmissionReportPage } from '@/pages/submission-report/ui/submission-report-page';

type SubmissionReportRouteProps = {
  params: Promise<{ submissionId: string }>;
};

export default async function SubmissionReportRoute({ params }: SubmissionReportRouteProps) {
  const { submissionId } = await params;
  return <SubmissionReportPage submissionId={submissionId} />;
}
