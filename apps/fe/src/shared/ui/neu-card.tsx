import type { ReactNode } from 'react';

type NeuCardProps = {
  title: string;
  description?: string;
  children: ReactNode;
};

export function NeuCard({ title, description, children }: NeuCardProps) {
  return (
    <section className="neu-surface" style={{ padding: 16 }}>
      <h2 style={{ margin: 0, fontSize: 18 }}>{title}</h2>
      {description ? (
        <p style={{ margin: '6px 0 14px', color: 'var(--muted)', fontSize: 14 }}>{description}</p>
      ) : null}
      {children}
    </section>
  );
}
