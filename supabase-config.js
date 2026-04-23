// Fill these two fields from Supabase Project Settings -> API Keys.
// `anonKey` here can use the browser-safe publishable key.
window.SUPABASE_CONFIG = {
    url: 'https://koeyjxlkygcibhkqyukl.supabase.co',
    anonKey: 'sb_publishable_dU1D8dPOYzE4-Il6L2G3lg_pcjQYifV'
};

// Hotfix: email sign-up can return a user before a logged-in session exists.
// Creating profiles is optional for sync, so skip it to avoid blocking registration.
window.addEventListener('DOMContentLoaded', () => {
    if (typeof upsertProfileRow === 'function') {
        upsertProfileRow = async function skipProfileUpsert() {};
    }
});

