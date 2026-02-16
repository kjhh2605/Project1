import type { ReactNode } from 'react';

type AppShellProps = {
  title: string;
  subtitle: string;
  actions?: ReactNode;
  children: ReactNode;
};

export function AppShell({ title, subtitle, actions, children }: AppShellProps) {
  return (
    <main>
      <div className="page-grid">
        <header className="page-header neu-surface">
          <div>
            <h1 className="page-title">{title}</h1>
            <p className="page-subtitle">{subtitle}</p>
          </div>
          {actions ? <div>{actions}</div> : null}
        </header>
        {children}
      </div>
    </main>
  );
}
