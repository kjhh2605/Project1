import Link from 'next/link';
import { AppShell } from '@/shared/ui/app-shell';

const links = [
  { href: '/problems/prob-101', label: 'Problem Workspace' },
  { href: '/submissions/sub-204/status', label: 'Submission Status' },
  { href: '/submissions/sub-204/report', label: 'Submission Report' }
];

export default function HomePage() {
  return (
    <AppShell
      title="Project1 UI Prototype"
      subtitle="뉴모피즘 기반 MVP 화면 설계"
      actions={<span className="neu-pill">Design Sprint</span>}
    >
      <section className="neu-surface" style={{ padding: 18 }}>
        <h2 style={{ margin: 0, fontSize: 18 }}>Screen Map</h2>
        <div style={{ marginTop: 12, display: 'grid', gap: 10 }}>
          {links.map((item) => (
            <Link key={item.href} className="neu-button" href={item.href} style={{ textAlign: 'left', width: '100%' }}>
              {item.label}
            </Link>
          ))}
        </div>
      </section>
    </AppShell>
  );
}
