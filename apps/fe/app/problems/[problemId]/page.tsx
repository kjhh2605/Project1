import { ProblemWorkspacePage } from '@/pages/problem-workspace/ui/problem-workspace-page';

type ProblemRouteProps = {
  params: Promise<{ problemId: string }>;
};

export default async function ProblemRoute({ params }: ProblemRouteProps) {
  const { problemId } = await params;
  return <ProblemWorkspacePage problemId={problemId} />;
}
