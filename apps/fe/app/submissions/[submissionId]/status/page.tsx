import { SubmissionStatusPage } from '@/pages/submission-status/ui/submission-status-page';

type SubmissionStatusRouteProps = {
  params: Promise<{ submissionId: string }>;
};

export default async function SubmissionStatusRoute({ params }: SubmissionStatusRouteProps) {
  const { submissionId } = await params;
  return <SubmissionStatusPage submissionId={submissionId} />;
}
