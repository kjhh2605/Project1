import { describe, expect, it } from 'vitest';
import { env } from '@/lib/env';

describe('env', () => {
  it('has a default API base URL', () => {
    expect(env.apiBaseUrl).toContain('http');
  });
});
